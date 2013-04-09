class SocketOrator < ApplicationOrator

  orator_name 'socket'

  on :open
  def open(_)
    self.user = { :channels => [] }
    user[:authenticated] = false
  end

  if Orator.debug
    on :error
    def error(data)
      pp data
      pp data.backtrace
    end

    on :missing
    def missing(data)
      pp data

      send message('socket.error', message: "No event with that name.",
        data: data)
    end
  end

end

Orator.add_orator(SocketOrator)
