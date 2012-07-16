Spine   = require('spine')
Manager = require('spine/lib/manager')
$       = Spine.$

Header  = require('controllers/shared/responsi_header')
Main    = require('controllers/responsi_main')
Frame   = require('controllers/responsi_frame')

class Responsis extends Spine.Controller
  className: 'responsi'
  
  constructor: ->
    super
    
    @header  = new Header
    @main    = new Main
    @frame   = new Frame

    @routes
      '/frame': ->
        @frame.index.active()
        @append @frame
      '/': (params) ->
        @header.index.active()
        @main.index.active()
    
    @append @header, @main
        
module.exports = Responsis