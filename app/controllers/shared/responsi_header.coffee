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
    "click .url-submit":  "submit"
    "change .sizes":      "changeSize"
    "click .rotate":      "rotate"

  constructor: ->
    super
    @active @change

  render: (params) ->
    @html require('views/shared/_header')
    $('#sizes').selectbox()
    @reLoadSizes()
    @setupBookmarklet()
    if params
      @loadUrl decodeURIComponent(params)

  change: (params) =>
    @render(params)

  submit: (e) ->
    e.preventDefault()
    if @urlInput.val()
      @loadUrl @urlInput.val()

  loadUrl: (url) ->
    @mainFrame = $('#main_frame')
    # Check the input has http:// if not add it
    if !url.match '^https?://'
      url = 'http://' + url
    # Set frame src to the url
    @mainFrame.attr 'src', url
    # Save url to localStorage
    localStorage.setItem 'url', url
    # Add url to url-input field
    @urlInput.val(url)

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

  rotate: (e) ->
    e.preventDefault()
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
    # data = "javascript:(function(){url=encodeURIComponent(window.location);alert(url)})()"
    data = "javascript:(function(){url=encodeURIComponent(window.location.href);window.location.href='http://respon.si/#/'+url;})()"
    @bookmarklet.attr('href', data).hover( 
      => @tip.slideDown 'slow'
      => @tip.slideUp 'slow'
    )

class Header extends Spine.Stack
  className: 'header stack'
    
  controllers:
    index: Index
    
module.exports = Header