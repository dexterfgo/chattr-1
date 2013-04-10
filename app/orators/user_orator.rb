class UserOrator < ApplicationOrator

  orator_name 'user'

  on :auth
  def auth(json)
    user_record = User.where(authentication_token: json["token"]).first

    if user_record
      send message('user.auth', result: true)
      user[:authenticated] = Time.now
    else
      send message('user.auth', result: false)
    end

    user[:record] = user_record
  end

  on 'channels.join' => :join_channel
  def join_channel(json)
    lookup = Channel.where(name: json["channel"]).first

    if lookup
      user[:channels] << lookup
      send message('user.channels.join', result: true, channel: json["channel"])
      broadcast message('channel.join', user: user[:record].for_message), lookup.name
    else
      send message('user.channels.join', result: false)
    end
  end

  on 'channels.leave' => :leave_channel
  def leave_channel(json)
    if user[:channels].select! { |ch|
      ch.name == json["channel"]
    } then
      send message('user.channels.leave', result: true, channel: json["channel"])
    else
      send message('user.channels.leave', result: false)
    end
  end

  on 'channels.list' => :list_channels
  def list_channels(_)
    send message('user.channels.list', channels: user.channels)
  end

  on :data
  def data(json)
    send message('user.data', user: user)
  end

end

Orator.add_orator(UserOrator)
