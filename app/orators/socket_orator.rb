class SocketOrator < ApplicationOrator

  def open(_)
    self.user = { :channels => [] }
    user[:authenticated] = Time.new 0
    send message('user.auth', {})
  end

  if Orator.debug
    def error(data)
      pp data
      pp data.backtrace
    end

    def missing(data)
      pp data

      send message('socket.error', message: "No event with that name.",
        data: data)
    end
  end

end

Orator.add_orator(SocketOrator)
