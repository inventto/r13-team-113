# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  $(".revert").on 'click', (e) ->
    Pixastic.revert(document.getElementById("testimage"))
  $(".invert").on 'click', (e) ->
    Pixastic.process(document.getElementById("testimage"), "invert")
  $(".desaturate").on 'click', (e) ->
    Pixastic.process(document.getElementById("testimage"), "desaturate")
  $(".brightness").on 'click', (e) ->
    Pixastic.process(document.getElementById("testimage"), "brightness", {brightness:50,contrast:0})
  $(".darkness").on 'click', (e) ->
    Pixastic.process(document.getElementById("testimage"), "brightness", {brightness:-50,contrast:0})
  $(".contrast").on 'click', (e) ->
    Pixastic.process(document.getElementById("testimage"), "brightness", {brightness:0,contrast:0.25})
  $(".laplace").on 'click', (e) ->
    Pixastic.process(document.getElementById("testimage"), "laplace", {edgeStrength:0.9,invert:false,greyLevel:0})
  $(".sepia").on 'click', (e) ->
    Pixastic.process(document.getElementById("testimage"), "sepia")
  $(".hue").on 'click', (e) ->
    Pixastic.process(document.getElementById("testimage"), "hsl", {hue:32,saturation:0,lightness:0})
  $(".solarize").on 'click', (e) ->
    Pixastic.process(document.getElementById("testimage"), "solarize")
  $(".slider").slider({orientation: "horizontal", value: 100})
  $(".slider").on "slidechange", ( event, ui ) ->
    $("#testimage").fadeTo(100, ui.value / 100) 

  dataURLtoBlob = (dataURL) ->
    binary = atob(dataURL.split(',')[1])
    array = []
    for i in binary.length
      array.push binary.charCodeAt(i)
    new Blob([new Uint8Array(array)], type: 'image/png')

  uploadImageFromUrl = (url) ->
     file= dataURLtoBlob(url)
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
