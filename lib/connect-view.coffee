{View, EditorView} = require 'atom'

module.exports =
class VncConnectView extends View
  @content: ->
    @div class: 'vnc overlay from-top panel bordered', =>
      @div class: "panel-heading", =>
         @div class: 'icon icon-telescope text-info', 'Connect to VNC server'
      @div class: "panel-body padded", =>
        @label 'Host:'
        @subview 'host', new EditorView(mini: true)
        @label 'Port:'
        @subview 'port', new EditorView(mini: true)
        @div class: 'block', outlet: 'buttonBlock', =>
          @button class: 'inline-block btn', outlet: 'cancelButton', 'Cancel'
          @button class: 'inline-block btn', outlet: 'okButton', 'OK'

  initialize: ->
    @on 'core:confirm', => @confirm()
    @okButton.on 'click', => @confirm()

    @on 'core:cancel', => @detach()
    @cancelButton.on 'click', => @detach()

    @host.setText('localhost')
    @port.setText('5900')
    @host.setPlaceholderText('vnc server host or ip (default localhost)')
    @port.setPlaceholderText('vnc server port       (default 5900)')

    atom.workspaceView.append(this)

  confirm: ->
    port = @port.getText()
    host = @host.getText()
    atom.workspace.open("vnc://#{host}:#{port}")
    @detach()

  destroy: ->
    @detach()
