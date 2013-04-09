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

end

Orator.add_orator(UserOrator)
