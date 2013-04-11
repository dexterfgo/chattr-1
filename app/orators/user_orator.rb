class UserOrator < ApplicationOrator

  on :auth
  def auth(json)
    user_record = User.where(authentication_token: json["token"]).first

    if user_record
      send message('user.auth.result', result: true)
      user[:authenticated] = Time.now
    else
      send message('user.auth.result', result: false)
    end

    user[:record] = user_record
  end

  def channels_join(json)
    lookup = Channel.where(name: json["channel"]).first

    if lookup
      broadcast message('channel.join', user: user[:record].for_message), lookup.name
      user[:channels] << lookup
      respond result: true, channel: json["channel"]
    else
      respond result: false
    end
  end

  def channels_leave(json)
    if user[:channels].select! { |ch|
      ch.name == json["channel"]
    } then
      respond result: true, channel: json["channel"]
    else
      respond result: false
    end
  end

  def channels_list(_)
    respond channels: user.channels
  end

  if Orator.debug
    def data(json)
      respond user: user
    end
  end

end

Orator.add_orator(UserOrator)
