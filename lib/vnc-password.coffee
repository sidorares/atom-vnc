{CompositeDisposable} = require 'atom'
{TextEditorView} = require 'atom-space-pen-views'
{View} = require 'space-pen'

# TODO:
# I don't like that user need to inderact with two dialog boxes
# - first, connection, second - auth info.
# Better flow: grey out connection info, don't close dialog ( maybe remove ok/cancel buttons)
# If server requires auth, append corresponding dialog under connection dialog

module.exports =
class VncPassword extends View
  @content: (params)->
    @div class: 'vnc password overlay from-top panel bordered', =>
      @div class: "panel-heading", =>
        @div class: 'icon icon-person text-info', outlet: 'info', "Connecting to #{params.host}:#{params.port} using VNC security type"
      @div class: "panel-body padded", =>
        @label 'Password:'
        @subview 'password', new TextEditorView(mini: true, password: true)
        @div class: 'block', outlet: 'buttonBlock', =>
          @button class: 'inline-block btn', outlet: 'cancelButton', 'Cancel'
          @button class: 'inline-block btn', outlet: 'okButton', 'OK'

  initialize: (params) ->
    @subscriptions = new CompositeDisposable

    @callback = params.callback
    @subscriptions.add atom.commands.add 'atom-workspace', 'core:confirm': => @confirm()
    @okButton.on 'click', => @confirm()

    @subscriptions.add atom.commands.add 'atom-workspace', 'core:cancel': => @detach()
    @cancelButton.on 'click', => @detach()
    atom.views.getView(atom.workspace).appendChild(@element)

    # emulate password asterisk
    # TODO: built-in way?
    # note that empty editor still contains '&nbsp'
    # and because of this we need to disable text-security when empty
    # otherwise empty password still displayed as *
    @subscriptions.add @password.getModel().getBuffer().onDidChange =>
      if @password.getText() is ''
        @password.css('-webkit-text-security': 'none')
      else
        @password.css('-webkit-text-security': 'disc')

  confirm: ->
    @callback(null, @password.getText())
    @detach()

  destroy: ->
    @subscriptions.dispose()
    @callback('cancel')
    @detach()
