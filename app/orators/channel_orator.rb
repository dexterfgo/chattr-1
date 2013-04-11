class ChannelOrator < ApplicationOrator

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

  def list(json)
    channels = Channel.scoped
    send message('channel.list', list: channels)
  end

  def users_list(json)
    in_channel = clients.select do |c|
      c.context.user[:channels].map(&:name).include?(json["channel"])
    end.map { |cl| cl.context.user[:record].for_message }

    send message('channel.users.list', list: in_channel)
  end

  def say(json)
    respond(result: false) if json["message"].length < 4

    Message.new do |m|
      m.user     = user[:record]
      m.channel  = channel
      m.body     = json["message"]
      m.reply_to = nil
    end.save

    broadcast message('channel.chat.say', sender: user[:record].for_message,
                      message: json["message"]), channel.name
    send message('channel.chat.say.result', result: true)

  end

  private

  before :only => ['channel.chat.say'] do |data|
    self.channel = Channel.where(:name => data["channel"]).first

    unless channel or user[:channels].include?(channel)
      prevent_event
      send message('channel.chat.say.result', result: false,
                   error: "No such channel.")
    end
  end

end

Orator.add_orator(ChannelOrator)
