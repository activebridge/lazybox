(($) ->
  defaults =
    esc: true
    close: true
    modal: false
    onTop: false
    cancelText: 'Cancel'
    cancelClass: 'btn'
    submitText: 'Ok'
    submitClass: 'btn'

  html = "<div id='lazy_overlay'><div id='lazybox'><a id='lazy_close' href=''></a><div id='lazy_body'></div></div></div>"
  box = overlay = close = null

  $.lazybox = (html, options) -> $.lazybox.show(html, options)

  $.extend $.lazybox,
    settings: $.extend {}, defaults

    show: (content, options) ->
      options = init(options)
      $('#lazy_body').html(content)
      setTimeout (-> overlay.addClass('visible')), 1
      close.addClass('visible') if options.close && !box.hasClass('visible')

    close: -> overlay.removeClass('visible')

    confirm: (element) ->
      options = $.extend defaults, $.lazybox.settings
      message = element.data('confirm')
      return true if !message
      $.lazybox.show('<p>'+message+'</p><div class="lazy_buttons"></div>', { klass: 'confirm' })
      element.clone().attr('class', options.submitClass).removeAttr('data-confirm').text(options.submitText).appendTo('.lazy_buttons')
      $('.lazy_buttons').append(' ')
      $('<a>', { href: '', text: options.cancelText, 'class': 'cancel ' + options.cancelClass }).appendTo('.lazy_buttons')
      return false

  $.fn.lazybox = (options) ->
    $(document).on 'click', this.selector, (e) ->
      a = $(e.currentTarget)
      href = a.attr('href')
      imagesRegexp = new RegExp('\\.(png|jpg|jpeg|gif)(\\?.*)?$', 'i')
      e.preventDefault()
      if href.match(imagesRegexp)
        img = new Image()
        img.onload = (element) -> $.lazybox.show(img, options)
        $(img).attr({ 'class': 'lazy-img', src: href })
      else
        $.ajax
          url: href
          success: (data) -> $.lazybox.show(data, options)
          error: -> $.lazybox.close()

  init = (options) ->
    options = $.extend {}, defaults, $.lazybox.settings, options
    $('body:not(:has(#lazybox))').append(html)
    box = $('#lazybox')
    overlay = $('#lazy_overlay')
    close = $('#lazy_close')
    if options.klass then box.attr('class', options.klass) else box.removeClass()
    if options.onTop then overlay.addClass('top') else overlay.removeClass('top')
    if options.close
      if options.closeImg then close.addClass('img') else close.removeClass('img')
    else
      close.removeClass()
    if options.modal
      overlay.unbind()
    else
      overlay.bind 'click', (e) ->
        $.lazybox.close() if e.target == @
    $(document).keyup (e) -> $.lazybox.close() if e.keyCode == 27 and options.esc
    box.on 'click', '#lazy_close, .lazy_buttons a.cancel', (e) ->
      $.lazybox.close()
      e.preventDefault()
    return options

) jQuery
