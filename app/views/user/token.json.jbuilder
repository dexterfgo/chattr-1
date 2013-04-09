if user_signed_in?
  json.token current_user.authentication_token
end
