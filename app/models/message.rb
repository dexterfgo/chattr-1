class Message < ActiveRecord::Base
  attr_accessible :body, :channel_id, :reply_to, :user_id

  belongs_to :channel, :inverse_of => :messages
  belongs_to :parent, :foriegn_key => :reply_to, :class_name => "Message"
  belongs_to :user, :inverse_of => :messages
end
