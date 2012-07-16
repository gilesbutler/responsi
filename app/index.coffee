require('lib/setup')
require('lib/jquery-ui')
require('lib/jquery.selectbox.min')

Spine    = require('spine')
Responsi = require('controllers/responsi')

class App extends Spine.Controller
  constructor: ->
    super
    @responsi = new Responsi
    @append @responsi.active()

    Spine.Route.setup(history: true)

module.exports = App