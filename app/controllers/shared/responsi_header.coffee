Spine = require('spine')
$     = Spine.$

class Index extends Spine.Controller
  className: 'index'
  tag: 'header'

  elements: 
    ".url-input":   "urlInput"
    ".url-submit":  "urlSubmit"
    "#sizes":       "sizes"
    "#bookmarklet": "bookmarklet"
    "#tip":         "tip"

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
    @reLoadSizes()
    @setupBookmarklet()

  change: (params) =>
    @render()

  loadUrl: (e) ->
    e.preventDefault()
    @mainFrame = $('#main_frame')
    @url = @urlInput.val()
    # Check to see if there is an input
    if @url
      # Check the input has http:// if not add it
      if !@url.match '^https?://'
        @url = 'http://' + @url
      # Set frame src to the url
      @mainFrame.attr 'src', @url
      # Save url to localStorage
      localStorage.setItem 'url', @url

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
      localStorage.setItem 'height', sizes.height
      localStorage.setItem 'width', sizes.width

  rotate: ->
    @frameHolder = $('#frame_holder')
    height = @frameHolder.height()
    width = @frameHolder.width()
    @frameHolder.height(width).width(height)

  reLoadSizes: ->
    width = localStorage.getItem "width"
    height = localStorage.getItem "height"
    if height and width
      $('.sbSelector').text(width + ' x ' + height)

  setupBookmarklet: ->
    data = "javascript:(function(){window.resizeTo(1280, 720)})();"
    @bookmarklet.attr('href', data).hover( 
      => @tip.slideDown 'slow'
      => @tip.slideUp 'slow'
    )

class Header extends Spine.Stack
  className: 'header stack'
    
  controllers:
    index: Index
    
module.exports = Header