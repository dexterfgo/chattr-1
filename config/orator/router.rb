Orator::Router.draw do

  event 'channel#new'
  event 'channel#list'
  event 'channel#users.list'
  event 'channel#chat.say'
  event 'user#auth'
  event 'user#channels.join'
  event 'user#channels.leave'
  event 'user#channels.list'
  event 'socket#open'

  if Orator.debug
    event 'socket#error'
    event 'socket#missing'
    event 'user#data'
  end

end
