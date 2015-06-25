{CompositeDisposable} = require 'atom'
{TextEditorView} = require 'atom-space-pen-views'
{View} = require 'space-pen'

module.exports =
class VncConnectView extends View
  @content: ->
    @div class: 'vnc overlay from-top panel bordered', =>
      @div class: "panel-heading", =>
        @div class: 'icon icon-telescope text-info', 'Connect to VNC server'
      @div class: "panel-body padded", =>
        @label 'Host:'
        @subview 'host', new TextEditorView(mini: true)
        @label 'Port:'
        @subview 'port', new TextEditorView(mini: true)
        @div class: 'block', outlet: 'buttonBlock', =>
          @button class: 'inline-block btn', outlet: 'cancelButton', 'Cancel'
          @button class: 'inline-block btn', outlet: 'okButton', 'OK'

  initialize: ->
    @subscriptions = new CompositeDisposable()

    @subscriptions.add atom.commands.add 'atom-workspace', 'core:confirm': => @confirm()
    @okButton.on 'click', => @confirm()

    @subscriptions.add atom.commands.add 'atom-workspace', 'core:cancel': => @detach()
    @cancelButton.on 'click', => @detach()

    @host.setText('localhost')
    @port.setText('5900')
    @host.getModel().setPlaceholderText('vnc server host or ip (default localhost)')
    @port.getModel().setPlaceholderText('vnc server port       (default 5900)')

    atom.views.getView(atom.workspace).appendChild(@element)

  confirm: ->
    port = @port.getText()
    host = @host.getText()
    atom.workspace.open("vnc://#{host}:#{port}")
    @detach()

  destroy: ->
    @subscriptions.dispose()
    @detach()
