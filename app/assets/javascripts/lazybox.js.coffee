( ($) ->
  defaults = {
    overlay: true,
    esc: true,
    close: true,
    modal: true,
    opacity: 0.3,
    onTop: false,
    speed: 300,
    fixed: false,
    cancelText: 'Cancel',
    cancelClass: 'button',
    submitText: 'Ok',
    submitClass: 'button'
  }

  html = "<div id='lazy_overlay'><div id='lazybox'><a id='lazy_close' href=''>×</a><div id='lazy_body'></div></div></div>"
  box = $('#lazybox')
  overlay = $('#lazybox_overlay')
  close = $('#lazybox_close')

  $.lazybox = (html, options) -> $.lazybox.show(html, options)

  $.extend $.lazybox,
    settings: $.extend {}, defaults

    show: (content, options) ->
      options = init(options)
      $('#lazy_body').html(content)
      overlay.addClass('visible') if options.overlay
      close.addClass('visible') if options.close
      $.lazybox.center(options.onTop, options.fixed)
      box.addClass('visible')
      return options

    close: (speed) ->
      overlay.removeClass('visible')
      box.removeClass('visible')

    center: (onTop, fixed) =>
      # if fixed
        # box.css({ position: 'fixed' })
      # else
        # box.css({ position: 'absolute' })

    confirm: (element) ->
      options = $.extend defaults, $.lazybox.settings
      message = element.data('confirm')
      return true if !message
      $.lazybox.show('<p>'+message+'</p><div class="lazy_buttons"></div>', { klass: 'confirm' })
      element.clone().attr('class', options.submitClass).removeAttr('data-confirm').text(options.submitText).appendTo('.lazy_buttons')
      $('.lazy_buttons').append(' ')
      $('<a>', { href: '', text: options.cancelText, 'class': options.cancelClass }).appendTo('.lazy_buttons')
      return false

  $.fn.lazybox = (options) ->
    $(document).on 'click', this.selector, (e) =>
      a = $(e.currentTarget)
      href = a.attr('href')
      imagesRegexp = new RegExp('\\.(png|jpg|jpeg|gif)(\\?.*)?$', 'i')
      e.preventDefault()
      if href.match(imagesRegexp)
        img = new Image()
        img.onload = (element) ->
          options = $.lazybox.show(img, options)
          nextLink = if a.is(':last-child') then a.siblings('a[rel*=lazybox]:first') else a.next('a[rel*=lazybox]:first')
          prevLink = if a.is(':first-child') then a.siblings('a[rel*=lazybox]:last') else a.prev('a[rel*=lazybox]:first')
          if nextLink.length and prevLink.length
            $('#lazy_body:not(:has(a#next_lazy_img))').append("<a id='prev_lazy_img' href=''><b>‹</b></a><a id='next_lazy_img' href=''><b>›</b></a>")
            $('#next_lazy_img, #prev_lazy_img').bind 'click', (event) ->
              event.preventDefault()
              box.removeClass('visible')
              if event.currentTarget.id == 'next_lazy_img' then nextLink.click() else prevLink.click()
        $(img).attr({ 'class': 'lazy_img', src: href })
      else
        $.ajax({
          url: href,
          success: (data) => $.lazybox.show(data, options)
          error: () => $.lazybox.close(options.speed) })

  init = (options) ->
    options = $.extend $.extend({}, defaults), $.lazybox.settings, options
    $('body:not(:has(#lazybox))').append(html)
    box = $('#lazybox')
    overlay = $('#lazy_overlay')
    close = $('#lazy_close')
    if options.klass then box.attr('class', options.klass) else box.removeClass()
    if options.close
      if options.closeImg then close.attr('class', 'img').text('') else close.removeClass().text('×')
    else close.removeClass()
    if !options.modal and options.overlay
      overlay.bind 'click', () => $.lazybox.close(options.speed)
    else
      overlay.unbind()
    $(document).keyup (e) ->
      $.lazybox.close(options.speed) if e.keyCode == 27 and options.esc
    box.on 'click', '#lazy_close, .lazy_buttons a', (e) => $.lazybox.close(options.speed); e.preventDefault()
    return options

) jQuery
