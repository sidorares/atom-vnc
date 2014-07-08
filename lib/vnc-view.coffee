url = require 'url'

{ScrollView} = require 'atom'

VncPassword = null
rfb         = null
keyMap      = null

# TODO: build inverse array, dont linear search
toRfbKeycode = (code, shift) ->
  keyMap ?= require './keycodes.coffee'
  for key in keyMap
    return key[if shift then 2 else 1] if code is key[0]
  null


module.exports =
class VncView extends ScrollView

  initialize: (params)->
    rfb ?= require 'rfb2'

    connectionParams = url.parse params.uri
    if connectionParams.hostname == ''
      connectionParams.hostname = '127.0.0.1'
    @connection = rfb.createConnection
      host: connectionParams.hostname
      port: connectionParams.port
      encodings: [rfb.encodings.raw, rfb.encodings.copyRect, rfb.encodings.pseudoDesktopSize]
      # TODO: support 'disconnect others' flag
      # connect dialog checkbox + rfb2 connect time option
      #shared: false


    # ask for next update each time we received rectangle
    # for very high latency connactions it might be better so send
    # update requests more often ( 100ms timer / mouse event etc )
    # for example, roundtrip from Australia to US west coast is ~300 ms -
    # 3 updates per sec with autoUpdate
    @connection.autoUpdate = true
    @buttonStateBitset = 0

    @connection.on 'connect', =>
      @connected = true
      @title = @connection.title
      @trigger 'title-changed'
      console.log(@connection)
      @offScreenCanvas
        .attr("width" , @connection.width)
        .attr("height", @connection.height)

      # TODO: scale
      @drawable
        .attr("width" , @connection.width)
        .attr("height", @connection.height)

    @connection.params.credentialsCallback = (cb)=>
      done = (err, password) ->
        return cb(password) unless err
        @connection.end()

      securityType = @connection.securityType
      if securityType is rfb.security.VNC
        VncPassword ?= require './vnc-password'
        dialog = new VncPassword
          host: @connection.params.host
          port: @connection.params.port
          callback: done
      else
        # TODO: display warning and disconnect
        # TODO: allow to specify list of preferred securrity types in connection dialog
        console.log("Unknown RFB security type: #{securityType}")

    @connection.on 'rect', (rect) =>
      @updateRectangle(rect)

    @connection.on 'resize', (size) =>
      @offScreenCanvas
        .attr("width" , size.width)
        .attr("height", size.height)
      # TODO: scale
      @drawable
        .attr("width" , size.width)
        .attr("height", size.height)


    @connection.on 'clipboard', (text) ->
      # TODO: add setting switch to selectively enable
      # atom <-> remote ( to / from / bidirectional)
      atom.clipboard.write(text)

    # TODO: is there an atom core event for clipboard?
    view = @
    lastClipboard = atom.clipboard.read()
    checkClipboard = ->
      currentClipboard = atom.clipboard.read()
      return if lastClipboard is currentClipboard
      lastClipboard = currentClipboard
      view.connection.updateClipboard(currentClipboard)
    @clipboardWatcher = setInterval checkClipboard, 50

    @ctx = @drawable[0].getContext('2d')

    #@ctx.scale(0.1, 0.1)
    #@drawable.disableSelection()
    #         .disableImageDrag()
    #         .disableContextMenu()

  updateRectangle: (rect)->

    # TODO: x11vnc + ncache
    # currently it's not possible to detect cache area of the screen
    # ssvnc tries to guess ncache based on 'screen too tall'. If
    # cache suspected, it then goes through list of well known resolutions and
    # sets height if width matches. If there is no match, 4:3 aspect ratio is used
    # http://sourcecodebrowser.com/ssvnc/1.0.27/desktop_8c.html#a35411bf9fc59dd97b1e7dd17fa2bc908

    # might be possible in the future using rfbFBCrop pseudoencoding (similar to desktop size)
    # http://www.karlrunge.com/x11vnc/faq.html#faq-client-caching
    #
    # At some point LibVNCServer may implement a "rfbFBCrop" pseudoencoding
    # that viewers can use to learn which portion of the framebuffer to
    # actually show to the users (with the hidden part used for caching, or
    # perhaps something else, maybe double buffering or other offscreen
    # rendering...).

    if rect.encoding is rfb.encodings.raw
      canvasRectangle = @ctx.createImageData(rect.width, rect.height)
      for i in [0..rect.buffer.length - 4] by 4
        # TODO: compile transformer function at run time ( noop if server pixel order is rgb )
        word = rect.buffer.readUInt32LE(i);
        r = (word & ( @connection.redMax   << @connection.redShift))   >> @connection.redShift
        g = (word & ( @connection.greenMax << @connection.greenShift)) >> @connection.greenShift
        b = (word & ( @connection.blueMax  << @connection.blueShift))  >> @connection.blueShift

        canvasRectangle.data[i + 0] = r;
        canvasRectangle.data[i + 1] = g;
        canvasRectangle.data[i + 2] = b;
        canvasRectangle.data[i + 3] = 255; # opaque

      @offScreenCanvas[0].getContext("2d").putImageData(canvasRectangle, rect.x, rect.y)
      @ctx.drawImage(@offScreenCanvas[0], 0, 0)

    else if rect.encoding is rfb.encodings.copyRect
      @ctx.drawImage(@offScreenCanvas[0], rect.src.x, rect.src.y, rect.width, rect.height, rect.x, rect.y, rect.width, rect.height)
      @offScreenCanvas[0].getContext("2d").drawImage(@offScreenCanvas[0], rect.src.x, rect.src.y, rect.width, rect.height, rect.x, rect.y, rect.width, rect.height)

    else
      # TODO there is nearly finished hextile support in rfb2 but it's not ready yet
      # also rle encoding seems to be low hanging fruit
      console.log("Unsupported rectangle encoding: #{rect.encoding}")

    # button 4,5
    @drawable.bind 'mousewheel', (event) =>
      offset = @drawable.offset()
      x = event.pageX - offset.left
      y = event.pageY - offset.top
      delta = event.originalEvent.wheelDelta
      if (delta > 0)
        @connection.pointerEvent(x, y, @buttonStateBitset | 1 << 3)
      else
        @connection.pointerEvent(x, y, @buttonStateBitset | 1 << 4)
      @connection.pointerEvent(x, y, @buttonStateBitset)
      console.log('Wheel!', event.originalEvent.wheelDelta)

  # mouse and keyboard support mostly copied
  # from https://github.com/sidorares/vnc-over-gif/blob/master/js.html#L206

  # TODO dry all mouse handlers
  mouseMove: (event, element) ->
    return if not @connected
    offset = element.offset()
    x = event.pageX - offset.left
    y = event.pageY - offset.top
    @connection.pointerEvent(x, y, @buttonStateBitset)

  mouseUp: (event, element) ->
    @buttonStateBitset &= ~(1 << (event.which-1))
    offset = element.offset()
    x = event.pageX - offset.left
    y = event.pageY - offset.top
    @connection.pointerEvent(x, y, @buttonStateBitset)

  mouseDown: (event, element) ->
    @buttonStateBitset |= 1 << (event.which-1)
    offset = element.offset()
    x = event.pageX - offset.left
    y = event.pageY - offset.top
    @connection.pointerEvent(x, y, @buttonStateBitset)

  # TODO: for some reason space pend hadler doe not work for me
  #mouseWheel: (event, element) ->
  #  #@connection.pointerEvent(x, y, 0)

  # TODO dry
  keyUp: (event, element) ->
    keyCode = toRfbKeycode(event.keyCode, event.shiftKey)
    @connection.keyEvent(keyCode, 0)

  keyDown: (event, element) ->
    keyCode = toRfbKeycode(event.keyCode, event.shiftKey)
    @connection.keyEvent(keyCode, 1)

  disableEvent: ->
    false

  @content: ->
    @div class: 'vnc pane-item', =>
      # @div class: 'loading loading-spinner-large inline-block', outlet: 'spinner'
      # TODO: handle reconnect
      @canvas
        width      : 80
        height     : 80
        # http://stackoverflow.com/questions/12886286/addeventlistener-for-keydown-on-canvas
        tabindex   : '1'
        outlet     : 'drawable'
        mousemove  : 'mouseMove'
        mousedown  : 'mouseDown'
        mouseup    : 'mouseUp'
        mousewheel : 'mouseWheel'
        keyup      : 'keyUp'
        keydown    : 'keyDown'
        keypress   : 'disableEvent'
        contextmenu: 'disableEvent'

      # http://stackoverflow.com/questions/3448347/how-to-scale-an-imagedata-in-html-canvas
      @canvas
        id    : 'offscreen'
        outlet: 'offScreenCanvas'

  destroy: ->
    @connection.end()
    clearInterval @clipboardWatcher
    @detach()

  # TODO: emit event (which?) that title is updated?
  # currently it's not visible in the tab because it's not here yet when
  # editor view is created. Or one can return promise object?
  getTitle: ->
    @title

  getIconName: -> 'telescope'
