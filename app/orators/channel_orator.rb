class ChannelOrator < ApplicationOrator

  orator_name 'channel'

  on :new
  def new(json)
    new_channel = Channel.new do |c|
      c.name  = json["channel"]
      c.owner = user[:record]
    end

    if new_channel.save
      send message('channel.new', result: true)
    else
      send message('channel.new', result: false, errors: new_channel.errors)
    end
  end

  on :list
  def list(json)
    channels = Channel.scoped
    send message('channel.list', list: channels)
  end

  on 'users.list', :users_list
  def users_list(json)
    in_channel = clients.select do |c|
      c.context.user[:channels].map(&:name).include?(json["channel"])
    end.map { |cl| cl.context.user[:record].for_message }

    send message('channel.users.list', list: in_channel)
  end

end

Orator.add_orator(ChannelOrator)
