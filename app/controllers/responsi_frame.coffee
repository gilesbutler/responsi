Spine = require('spine')
$     = Spine.$

class Index extends Spine.Controller
  className: 'index'
  tag: 'section'

  constructor: ->
    super
    @active @change

  render: ->
    @html require('views/frame')
    document.getElementsByTagName('body')[0].className+=' loadFrame'

  change: ->
    @render()

class Frame extends Spine.Stack
  className: 'frame stack'
    
  controllers:
    index: Index
    
module.exports = Frame