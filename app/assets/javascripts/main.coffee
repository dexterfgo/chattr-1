$ ->

  return unless $("#chat").length > 0

  window.helper =
    tmp_data: null

    find_token: (cb)->
      $.ajax("/user/token.json", success: cb)

    server_auth: ()->
      helper.find_token (data)->
        orator.server.send('user.auth', token: data.token || null)

  orator = Orator.setup "ws://#{location.hostname}:8080/", (events)->

    @on 'socket.open', ()->
      helper.tmp_data = ()->
        new_channel = if location.hash.length > 0
          location.hash
        else
          "#root"

        @server.send('user.channels.join', channel: new_channel)
        @chat.append({
          sender: 'system', class: 'system', avatar: '/assets/system.png',
          body: "Joining channel <c>{{channel}}</c>", data: { channel: new_channel } })

    @on 'user.auth', (data)->
      if data.original_message
        helper.tmp_data = data.original_message
      helper.server_auth()

    @on 'user.auth.result', (data)->
      if data.result
        if helper.tmp_data
          if $.isFunction helper.tmp_data
            helper.tmp_data.apply(@, data)
          else
            @server.send(helper.tmp_data["event"], helper.tmp_data)

          helper.tmp_data = null
      else
        console.warn(data)

    @on 'channel.chat.say', (data)->
      @chat.append({
        sender: data.sender.name, class: 'chat', avatar: data.sender.avatar,
        body: "{{message}}", data: data
      })


  helper.orator  = orator
  orator.command = new orator.libs.CommandHandler
  orator.chat = new orator.libs.ChatLogger(format: """
    <li class='row-fluid mbm {{classes}}'>
      <div class='info span1'>
        <span class='avatar'><img src='{{avatar}}'></span>
        <span class='sender'>{{sender}}</span>
      </div>
      <div class='body span11 pam'>{{-formatted_body}}</div>
    </li>
    """, element: $("#chat"))

  force_size = ()->
    console.log("Force Size")

    $("#chat").height($(window).height() - 150)

  force_size()
  $(window).resize(force_size)

  $("#chat-input").on 'keyup', (event)->

    if event.which is 13
      value = $(event.target).val()
      $(event.target).val("")

      if value[0] == '/'
        helper.orator.command.run(value.slice(1))
      else
        helper.orator.server.send("channel.chat.say", {  message: value, \
                                  channel: location.hash})


  #$(window).hashchange ()->
  #  location.hash # => different now
