class Channel < ActiveRecord::Base
  attr_accessible :name

  validates :name, :format => { :with => /\A\#/ }, :length => { :in => 3..20 },
    :presence => true, :uniqueness => true

  has_many :messages
  has_many :users, :through => :messages
  has_and_belongs_to_many :admins, :class_name => "User",
    :join_table => "admins_channels"
  belongs_to :owner, :class_name => "User"
end
