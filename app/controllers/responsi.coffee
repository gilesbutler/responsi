Spine   = require('spine')
Manager = require('spine/lib/manager')
$       = Spine.$

Header  = require('controllers/shared/responsi_header')
Main    = require('controllers/responsi_main')

class Responsis extends Spine.Controller
  className: 'responsi'
  
  constructor: ->
    super
    
    @header  = new Header
    @main    = new Main

    @routes
      '/:url': (params) ->
        @header.index.active(params.url)
        @main.index.active()
    
    @append @header, @main
        
module.exports = Responsis