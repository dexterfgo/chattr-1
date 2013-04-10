class ApplicationOrator < Orator::Base

  before do |json|
    next if ['user.auth', 'socket.open', 'socket.close',
      'socket.error'].include?(full_event)

      if (!self[:user]) || user[:authenticated] < (Time.now - 600)
        send message('user.auth_required', original_message: json)
        prevent_event
      end

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
      c.context.send({ "_broadcast" => true }.merge(message))
    end
  end

end
