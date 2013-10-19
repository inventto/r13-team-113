# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  $(".revert").on 'click', (e) ->
    Pixastic.revert(document.getElementById("baseimage"))
  $(".invert").on 'click', (e) ->
    Pixastic.process(document.getElementById("baseimage"), "invert")
  $(".desaturate").on 'click', (e) ->
    Pixastic.process(document.getElementById("baseimage"), "desaturate")
  $(".brightness").on 'click', (e) ->
    Pixastic.process(document.getElementById("baseimage"), "brightness", {brightness:50,contrast:0})
  $(".darkness").on 'click', (e) ->
    Pixastic.process(document.getElementById("baseimage"), "brightness", {brightness:-50,contrast:0})
  $(".contrast").on 'click', (e) ->
    Pixastic.process(document.getElementById("baseimage"), "brightness", {brightness:0,contrast:0.25})
  $(".laplace").on 'click', (e) ->
    Pixastic.process(document.getElementById("baseimage"), "laplace", {edgeStrength:0.9,invert:false,greyLevel:0})
  $(".sepia").on 'click', (e) ->
    Pixastic.process(document.getElementById("baseimage"), "sepia")
  $(".hue").on 'click', (e) ->
    Pixastic.process(document.getElementById("baseimage"), "hsl", {hue:32,saturation:0,lightness:0})
  $(".solarize").on 'click', (e) ->
    Pixastic.process(document.getElementById("baseimage"), "solarize")
  $(".transparent").on 'click', (e) ->
    Pixastic.process(document.getElementById("baseimage"), "transparent")
  $(".transparent2").on 'click', (e) ->
    Pixastic.process(document.getElementById("baseimage"), "transparent", {white: true})
  $(".slider").slider({orientation: "horizontal", value: 100})
  $(".slider").on "slidechange", ( event, ui ) ->
    $("#baseimage").fadeTo(100, ui.value / 100)

  window.URL = window.URL || window.webkitURL
  navigator.getUserMedia  = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia
  video = $('#capture video')[0]
  canvas = $('#capture canvas.camera')[0]
  ctx = canvas.getContext('2d')
  localMediaStream = null

  snapshot = ->
    if (localMediaStream)
      console.log video
      ctx.drawImage(video, 0, 0)
      blob =  canvas.toDataURL('image/webp')
      document.querySelector('img').src = blob
      uploadImageFromBlob blob

  $("#snapshot-button").on "click", snapshot
  video.addEventListener('click', snapshot, false)
  sourceStream = (stream) ->
    video.src = window.URL.createObjectURL(stream)
    localMediaStream = stream

  onFailSoHard = -> {}
  navigator.getUserMedia video: true, sourceStream, onFailSoHard

  uploadImageFromBlob = (blob) ->
     fd = new FormData()
     fd.append("image", blob)
     $.ajax
       url: window.location.pathname.replace('edit','add_image'),
       data: fd,
       type: 'POST',
       processData: false,
       contentType: false,
       success: (data) ->
         console.log("enviou imagem e recebeu ", data)
