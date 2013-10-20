# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  Pixastic.init()

  $("div[withEffect]").on 'click', (e) ->
    base_image = $("#base-image")[0]
    current_effect = $(e.currentTarget).attr("class")
    console.log current_effect
    switch current_effect
      when "revert" then Pixastic.revert(base_image)
      when "brightness" then Pixastic.process(base_image, "brightness", {brightness:50,contrast:0})
      when "darkness" then Pixastic.process(base_image, "brightness", {brightness:-50,contrast:0})
      when "contrast" then Pixastic.process(base_image, "brightness", {brightness:0,contrast:0.25})
      when "laplace" then  Pixastic.process(base_image, "laplace", {edgeStrength:0.9,invert:false,greyLevel:0})
      when "hue" then Pixastic.process(base_image, "hsl", {hue:32,saturation:0,lightness:0})
      when "transparent2" then Pixastic.process(base_image, "transparent", {white: true})
      else
        Pixastic.process(base_image, current_effect)

    $.ajax type:"PUT", url: $('form')[0].action, data:{project:{baseimage_effect: current_effect}}

  $("#slider-opacity").slider({orientation: "vertical", value: 50})
  $("#base-image").fadeTo(200, 0.5)
  $("#slider-opacity").on "slidechange", ( event, ui ) ->
    if $('#opacity-type')[0].checked
      Pixastic.revert(document.getElementById("base-image"))
      Pixastic.process(document.getElementById("base-image"), "chess", {size: ui.value})
    else
      $("#base-image").fadeTo(100, ui.value / 100)


  $('#config-button').on 'click', (e) ->
    if $(e.currentTarget).hasClass('active')
      $("#controls img").removeClass('active')
      $('#context-container > div').hide(100)
    else
      active_context('config-context')
      $("#controls img").removeClass('active')
      $(this).addClass('active')

  $('#save-button').on 'click', (e) ->
    $('#form').submit()

  $('#new-button').on 'click', (e) ->
    window.location = "/projects/new"

  $('#list-button').on 'click', (e) ->
    window.location = "/projects"

  $('#download-button').on 'click', (e) ->
    window.location = window.location.pathname.replace('edit','export')

  $('#images-button').on 'click', (e) ->
    if $(e.currentTarget).hasClass('active')
      $("#controls img").removeClass('active')
      $('#context-container > div').hide(100)
    else
      active_context('images-context')
      $("#controls img").removeClass('active')
      $(this).addClass('active')

   $.contextMenu
     selector: '#images-context img'
     trigger: 'hover'
     delay: 100
     autoHide: true
     callback: (key, options) ->
       img = options.$trigger[0]
       if key == "use_as_base_image"
         $('#base-image').attr 'src', $(img).attr('data-content')
         $.ajax type:"PUT", url: $('form')[0].action, data:{project:{imagebase_id: $(img).attr('data-id')}}
	 #$('body').scrollTop('#base-image')
       else if key == "delete"
         if confirm('Delete?')
           img.remove()
           $.ajax type:"DELETE", url: "/projects/image/" + $(img).attr('data-id')
     items:
       "use_as_base_image": {
         name: " Base Image",
         icon: "hand-up"
       }
       "delete": {
         name: " Delete",
         icon: "remove"
       }


  load_thumb_effects = ->
    # FIXME: Don't show the captured image
    #thumb_canvas = $('#capture canvas.thumb-camera')[0]
    #thumb_blob = thumb_canvas.toDataURL('image/webp')
    #$('#effects img').attr 'src', thumb_blob
    #$('#effects canvas').each (i, e) ->
    #  _ctx = e.getContext('2d')
    #  _ctx.clearRect(4,4,24,24)
    #  _img = new Image()
    #  _img.src = thumb_blob
    #  _ctx.drawImage(_img,-32,-32,thumbSize,thumbSize)
    #Pixastic.init()

  active_context = (context) ->
    $('#context-container > div').hide(100)
    $('#'+context).show(100)
    #$('body').scrollTop('#' + context)

  window.URL = window.URL || window.webkitURL
  navigator.getUserMedia  = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia
  video = $('#capture video')[0]
  canvas = $('#capture canvas.camera')[0]
  thumb_canvas = $('#capture canvas.thumb-camera')[0]
  thumbSize = 128
  thumb_canvas.width = thumbSize
  thumb_canvas.height = thumbSize
  canvas.width = 500
  canvas.height = 500
  ctx = canvas.getContext('2d')
  thumb_ctx = thumb_canvas.getContext('2d')
  localMediaStream = null

  snapshot = ->
    if (localMediaStream)
      diffH = video.clientHeight - canvas.height
      diffW = video.clientWidth - canvas.width
      diffHT = diffH * thumbSize / canvas.height
      diffWT = diffW * thumbSize / canvas.width
      thumbWidth = thumbSize * video.clientWidth / video.clientHeight

      ctx.drawImage(video, -diffW / 2, -diffH / 2, video.clientWidth, video.clientHeight)
      thumb_ctx.drawImage(video, -diffWT / 2, -diffHT / 2, thumbWidth, thumbSize)
      blob =  canvas.toDataURL('image/png')
      thumb_blob = thumb_canvas.toDataURL('image/png')
      $('img#captured-image').attr 'src', blob
      if $('#use_as_base')[0].checked
        $('img#base-image').attr 'src', blob
      $('img#thumbimage').attr 'src', thumb_blob

      uploadImageFromBlob blob, thumb_blob

      $('img#thumbimage').hide()
      $('img#captured-image').show()
      $(video).hide()
      load_thumb_effects()
      $('body').css({opacity: 0})
      $('body').animate({opacity: 1}, 300 )

  window.firstPic = true
  pic = false
  $("#snapshot-button").on "click", ->
    if pic
      this.src = "/images/plussnapbutton.png"
      snapshot()
      $('#base-image').show()
    else
      if window.firstPic
        window.firstPic = false
        $('#base-image').hide()
      this.src = "/images/snapbutton.png"
      $('img#captured-image').hide()
      $('img#thumbimage').hide()
      $(video).show()
    pic = !pic

  video.addEventListener('click', snapshot, false)
  sourceStream = (stream) ->
    video.src = window.URL.createObjectURL(stream)
    localMediaStream = stream

  onFailSoHard = -> {}
  navigator.getUserMedia video: true, sourceStream, onFailSoHard

  uploadImageFromBlob = (blob, thumb_blob) ->
     fd = new FormData()
     fd.append("image", blob)
     fd.append("thumb", thumb_blob)
     $.ajax
       url: window.location.pathname.replace('edit','add_image'),
       data: fd,
       type: 'POST',
       processData: false,
       contentType: false,
       success: (data) ->
         console.log("enviou imagem e recebeu ", data.external_path)
         $('#images-context').append('&nbsp;<img class="image-thumb" src="' +data.external_thumb_path + '" data-content="' + data.external_path + '" data-id="' + data.id +  '" />')
