Spine = require('spine')
$     = Spine.$

class Index extends Spine.Controller
  className: 'index'
  tag: 'header'

  elements: 
    ".url-input":   "urlInput"
    ".url-submit":  "urlSubmit"
    "#sizes":       "sizes"

  events: 
    "click .url-submit":  "loadUrl"
    "change .sizes":      "changeSize"
    "click .rotate":      "rotate"

  constructor: ->
    super
    @active @change

  render: ->
    @html require('views/shared/_header')
    $('#sizes').selectbox()

  change: (params) =>
    @render()

  loadUrl: (e) ->
    e.preventDefault()
    @mainFrame = $('#main_frame')
    @url = @urlInput.val()
    if @url
      @mainFrame.attr('src', @url)

  changeSize: (e) ->
    e.preventDefault()
    @frameHolder = $('#frame_holder')
    $('#intro').fadeOut()
    index = e.currentTarget.selectedIndex
    if index is 0 and e.currentTarget[0].value is '---'
      return false
    else
      sizes = $(e.currentTarget[index]).data()
      @frameHolder.height(sizes.height).width(sizes.width)

  rotate: ->
    @frameHolder = $('#frame_holder')
    height = @frameHolder.height()
    width = @frameHolder.width()
    @frameHolder.height(width).width(height)

class Header extends Spine.Stack
  className: 'header stack'
    
  controllers:
    index: Index
    
module.exports = Header