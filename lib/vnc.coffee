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
    atom.workspaceView.command 'vnc:open', vncOpen

    atom.workspace.registerOpener (uri) ->
      u = url.parse(uri)
      if u.protocol == vncProtocol
        createVncView
          uri: uri
