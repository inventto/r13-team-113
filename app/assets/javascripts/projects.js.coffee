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
      ctx.drawImage(video, 0, 0)
      $('img#captured-image')[0].src = canvas.toDataURL('image/webp')
      $('img#baseimage')[0].src = canvas.toDataURL('image/webp')
      $('img#captured-image').show()
      $(video).hide()

  pic = true
  $("#snapshot-button").on "click", ->
    if pic
      snapshot()
    else
      $('img#captured-image').hide()
      $(video).show()
    pic = !pic
  video.addEventListener('click', snapshot, false)
  sourceStream = (stream) ->
    video.src = window.URL.createObjectURL(stream)
    localMediaStream = stream

  onFailSoHard = -> {}
  navigator.getUserMedia video: true, sourceStream, onFailSoHard

  uploadImageFromCanvas = (canvas) ->
     file = canvas.getContext()
     fd = new FormData()
     fd.append("image", file)
     $.ajax
       url: window.location.url.toString()+"/images"
       type: "POST"
       data: fd
       processData: false
       contentType: false
       success: (data) ->
         console.log("enviou imagem e recebeu ", data)
