{CompositeDisposable} = require 'atom'

url     = require 'url'

VncView = null
VncConnectView = null

vncProtocol = 'vnc:'

vncOpen = ()->
  VncConnectView ?= require './connect-view'
  new VncConnectView()

createVncView = (opts) ->
  VncView ?= require('./vnc-view')
  new VncView(opts)

module.exports =
  activate: (state) ->
    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.commands.add 'atom-workspace', 'vnc:open': -> vncOpen()

    atom.workspace.addOpener (uri) ->
      u = url.parse(uri)
      if u.protocol == vncProtocol
        createVncView
          uri: uri

  deactivate: ->
    @subscriptions.dispose()
