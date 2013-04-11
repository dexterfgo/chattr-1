class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :token_authenticatable,
         :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation,
    :remember_me, :avatar

  validates :name, :length => { :in => 3..20 }, :presence => true,
    :uniqueness => true

  before_save :reset_authentication_token
  before_create do
    write_attribute(:uuid, SecureRandom.uuid)
  end

  has_many :messages, :inverse_of => :user
  has_many :message_channels, :class_name => "Channel", :through => :messages,
    :inverse_of => :users
  has_and_belongs_to_many :channels, :join_table => "admins_channels"
  has_attached_file :avatar,
    :styles => { :default => "x64" },
    :default_url => "/assets/system.png",
    :path => ":rails_root/public/avatars/:hash.:extension",
    :hash_secret => "345olnsid0349jipsa0fdfai8o43qb15ionkfdlsi3o4n5iolsasdfasd8943n",
    :url => "/avatars/:hash.:extension"

  def for_message
    {
      :name => name,
      :uuid => uuid,
      :avatar => avatar.url(:default)
    }
  end

end
