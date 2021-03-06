Spine = require('spine')
$     = Spine.$

Intro = require('views/shared/_intro')

class Index extends Spine.Controller
  className: 'index'
  tag: 'section'

  elements:
    '#frame_holder':          'frameHolder'
    '#main_frame':            'mainFrame'
    '#intro':                 'intro'
    '#resizer':               'resizer'

  constructor: ->
    super
    @active @change

  render: (params) ->
    @html require('views/index')
    # Check if user has loaded app already
    @firstLoad()
    # Check for url in parameters then in localStorage
    if params
      @loadUrl decodeURIComponent(params)
    else
      @reLoadUrl()
    # Check for sizes in localStorage
    @reLoadSizes()
    # Setup resize plugin
    @setupResizing()

  setupResizing: ->
    mask = document.querySelector '.mask'
    sizes = document.getElementById 'sizes'
    @frameHolder.resizable
      start: (event, ui) ->
        #enable a mask over the Iframe to prevent it from stealing mouse events
        mask.style.display = 'block'
        $("#sizes").selectbox("close")
        $('#intro').fadeOut('slow')
      stop: (event, ui) =>
        # remove mask when dragging ends
        mask.style.display = 'none'
        # save size to sizes dropdown and localStorage
        @saveSize()

  saveSize: ->
    dimensions = Math.round(@frameHolder.width()) + ' x ' + Math.round(@frameHolder.height())
    $('.sbSelector').text(dimensions)
    $('.sbOptions li:first a').text(dimensions)
    localStorage.setItem "width", Math.round(@frameHolder.width())
    localStorage.setItem "height", Math.round(@frameHolder.height())

  change: (params) =>
    @render(params)

  firstLoad: ->
    # Check to see if the user has already loaded the app
    height = localStorage.getItem "height"
    width = localStorage.getItem "width"
    loaded = localStorage.getItem "loaded"
    mql = window.matchMedia "(max-width: 768px)"
    if height and width and loaded
      @loaded = true
    if !@loaded
      if mql.matches is false
        @append Intro
      localStorage.setItem "loaded", true

  loadUrl: (params) ->
    if !params.match '^https?://'
      params = 'http://' + params
    @mainFrame.attr 'src', params

  reLoadUrl: ->
    @urlInput = $('.url-input')
    @url = localStorage.getItem "url"
    # Check local storage for previous url
    if @url
      @mainFrame.attr 'src', @url
      @urlInput.val(@url)

  reLoadSizes: ->
    width = localStorage.getItem "width"
    height = localStorage.getItem "height"
    if height and width
      @frameHolder.height(height).width(width)


class Main extends Spine.Stack
  className: 'main stack'
    
  controllers:
    index: Index
    
module.exports = Main