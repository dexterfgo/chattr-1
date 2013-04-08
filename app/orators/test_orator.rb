class TestOrator < Orator::Base

  orator_name 'test'

  on :first_user
  def first_user(_)
    send message('test.first_user', user: User.first.attributes)
  end

end

Orator.add_orator(TestOrator)

Orator.add_orator do |events|

  events.on 'socket.error' do |error|
    p error

    puts error.message
    puts error.backtrace
  end

end
