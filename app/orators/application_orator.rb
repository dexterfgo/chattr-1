class ApplicationOrator < Orator::Base

  before do |json|
    unless ['user.auth', 'socket.open', 'socket.close', 
      'socket.error'].include?(full_event)

      if (!self[:user]) || user[:authenticated] < (Time.now - 600)
        send message('user.auth_required', original_message: json)
        prevent_event
      end

    end
  end

end
