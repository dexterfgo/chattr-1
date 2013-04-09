class SocketOrator < ApplicationOrator

  orator_name 'socket'

  on :open
  def open(_)
    self.user = {}
    user[:authenticated] = false
  end

  if Orator.debug
    on :error
    def error(data)
      pp data
      pp data.backtrace[0..5]
    end
  end

end

Orator.add_orator(SocketOrator)
