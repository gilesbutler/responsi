Spine = require('spine')
$     = Spine.$

class Index extends Spine.Controller
  className: 'index'
  tag: 'header'

  elements: 
    ".url-input":         "urlInput"
    ".url-submit":        "urlSubmit"
    "#sizes":             "sizes"
    "#bookmarklet":       "bookmarklet"
    "#tip":               "tip"
    "#alerts":            "alerts"
    ".alert-close":       "alertClose"
    ".alert-title span":  "alertTitle"
    ".alert-message":     "alertMessage"

  events: 
    "click .url-submit":  "submitUrl"
    "change .sizes":      "changeSize"
    "click .rotate":      "rotate"
    "click .alert-close": "closeAlert"

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
    @checkForIpad()

  change: (params) =>
    @render(params)

  submitUrl: (e) ->
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
    # Check to see if the we are on the first size and its value is ---
    index = e.currentTarget.selectedIndex
    if index is 0 and e.currentTarget[0].value is '---'
      return false
    else
      sizes = $(e.currentTarget[index]).data()
      if sizes.width > $('body').width()
        $('body').width(sizes.width + 20)
      else
        $('body').width('')
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
      if width > $('body').width()
        $('body').width(parseInt(width) + 20)

  setupBookmarklet: ->
    data = "javascript:(function(){url=encodeURIComponent(window.location.href);window.location.href='http://respon.si/#/'+url;})()"
    @bookmarklet.attr('href', data).hover( 
      => @tip.slideDown 'slow'
      => @tip.slideUp 'slow'
    )

  closeAlert: (e) ->
    e.preventDefault()
    @alerts.slideUp()

  showAlert: (title, message) ->
    if title
      @alertTitle.text title
    if message
      @alertMessage.text message
    if title or message
      @alerts.slideDown()

  checkForIpad: ->
    ua = navigator.userAgent
    isiPad = /iPad/i.test(ua) || /iPhone OS 3_1_2/i.test(ua) || /iPhone OS 3_2_2/i.test(ua)
    noticeDisplayed = localStorage.getItem "noticeDisplayed"
    if isiPad
      if !noticeDisplayed
        @showAlert 'Notice', 'iPad support is currently experimental.'
        localStorage.setItem "noticeDisplayed", true
      @changeUrlInputType()

  changeUrlInputType: ->
    document.querySelector('.url-input').type = 'url'

class Header extends Spine.Stack
  className: 'header stack'
    
  controllers:
    index: Index
    
module.exports = Header