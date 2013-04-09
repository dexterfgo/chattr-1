$ ->

  return unless $("#chat").length > 0

  tmp_data = null
  find_token = (cb)->
    $.ajax("/user/token.json", success: cb)

  server_auth = ()-> find_token (data)->
    orator.server.send('user.auth', token: data.token || null)

  window.orator = Orator.setup "ws://#{location.hostname}:8080/", (events)->

    @on 'socket.open', ()->
      server_auth()

      tmp_data = ()->
        new_channel = if location.hash.length > 0 
          location.hash 
        else 
          "#root"

        @server.send('user.channel', channel: new_channel)
        @chat.append({
          sender: 'system', class: 'system', avatar: '/assets/system.png', 
          body: "Joining channel <c>{{channel}}</c>", data: { channel: new_channel } })

    @on 'user.auth', (data)->
      if data.result
        if tmp_data
          if $.isFunction tmp_data
            tmp_data.apply(@, data)
          else
            @server.send(tmp_data["event"], tmp_data)
      else
        console.warn(data)


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

  $(window).hashchange ()->
    location.hash # => different now
