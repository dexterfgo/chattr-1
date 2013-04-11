class ApplicationOrator < Orator::Base

  before do |json|
    next if ['user.auth', 'socket.open', 'socket.close',
      'socket.error'].include?(full_event)

    # If the user object doesn't exist or their authentication is up, force
    # them to authenticate.
    if user[:authenticated] < (Time.now - 600)
      send message('user.auth', original_message: json)
      prevent_event
    end
  end

  # The first argument is the message that should be broadcasted.  The block
  # selects the clients that will receive the message.
  #
  # @param message [Hash] the message to send.
  # @yieldparam [Client] a client.
  # @yieldreturn [Boolean] whether or not to send to that client.
  # @return [void]
  def broadcast(message, to_channel = nil, &block)
    block = (block || proc do |c|
      c.context.user[:channels].map(&:name).include?(to_channel)
    end)

    clients.select(&block).map do |c|
      c.context.send({ "_broadcast" => true, "_time" => Time.now.to_f }.merge(message))
    end
  end

  # This responds to the client with the current event as the event.  It sends
  # the data as well.
  #
  # @param data [Hash] the message to send.
  def respond(data)
    send message(full_event, data)
  end

end
