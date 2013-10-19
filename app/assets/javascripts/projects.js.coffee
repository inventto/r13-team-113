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

  
