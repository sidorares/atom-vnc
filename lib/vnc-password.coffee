{View, EditorView} = require 'atom'

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
        @subview 'password', new EditorView(mini: true, password: true)
        @div class: 'block', outlet: 'buttonBlock', =>
          @button class: 'inline-block btn', outlet: 'cancelButton', 'Cancel'
          @button class: 'inline-block btn', outlet: 'okButton', 'OK'

  initialize: (params)->
    @callback = params.callback
    @on 'core:confirm', => @confirm()
    @okButton.on 'click', => @confirm()

    @on 'core:cancel', => @detach()
    @cancelButton.on 'click', => @detach()
    atom.workspaceView.append(this)

    # emulate password asterisk
    # TODO: built-in way?
    # note that empty editor still contains '&nbsp'
    # and because of this we need to disable text-security when empty
    # otherwise empty password still displayed as *
    @password.getEditor().getBuffer().on 'changed', ()=>
      if @password.getText() is ''
        @password.find('.lines').css('-webkit-text-security': 'none')
      else
        @password.find('.lines').css('-webkit-text-security': 'disc')

  confirm: ->
    @callback(null, @password.getText())
    @detach()

  destroy: ->
    @callback('cancel')
    @detach()
