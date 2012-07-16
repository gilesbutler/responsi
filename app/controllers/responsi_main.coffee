Spine = require('spine')
$     = Spine.$

class Index extends Spine.Controller
  className: 'index'
  tag: 'section'

  elements:
    '#frame_holder':  'frameHolder'
    '#intro':         'intro'

  constructor: ->
    super
    @active @change

  render: ->
    @html require('views/index')
    mask = document.querySelector '.mask'
    sizes = document.getElementById 'sizes'
    $sbSelector = $('.sbSelector', '#controls')
    $sbOptionsFirst = $('.sbOptions li:first a', '#controls')
    @frameHolder.resizable
      start: (event, ui) ->
        #enable a mask over the Iframe to prevent it from stealing mouse events
        mask.style.display = 'block'
        $("#sizes").selectbox("close")
        $('#intro').fadeOut('slow')
      resize: (event, ui) ->
        dimensions = event.clientX + ' x ' + event.clientY
        # sizes[0].selected = true
        $sbSelector.text(dimensions)
        $sbOptionsFirst.text(dimensions)
      stop: (event, ui) ->
        # remove mask when dragging ends
        mask.style.display = 'none'

  change: (params) =>
    @render()

class Main extends Spine.Stack
  className: 'main stack'
    
  controllers:
    index: Index
    
module.exports = Main