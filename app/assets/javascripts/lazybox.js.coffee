( ($) ->
  defaults = {
    overlay: true,
    esc: true,
    close: true,
    modal: true,
    onTop: false,
    cancelText: 'Cancel',
    cancelClass: 'button',
    submitText: 'Ok',
    submitClass: 'button'
  }

  html = "<div id='lazy_overlay'><div id='lazybox'><a id='lazy_close' href=''></a><div id='lazy_body'></div></div></div>"
  box = $('#lazybox')
  overlay = $('#lazy_overlay')
  close = $('#lazy_close')

  $.lazybox = (html, options) -> $.lazybox.show(html, options)

  $.extend $.lazybox,
    settings: $.extend {}, defaults

    show: (content, options) ->
      options = init(options)
      $('#lazy_body').html(content)
      setTimeout (->
        overlay.addClass('visible') if options.overlay
        close.addClass('visible') if options.close
        box.addClass('visible')
        ), 10
      return options

    close: ->
      overlay.removeClass('visible')

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
            $('#lazy_body:not(:has(a#next_lazy_img))').append("<a id='prev_lazy_img' href=''></a><a id='next_lazy_img' href=''></a>")
            $('#next_lazy_img, #prev_lazy_img').bind 'click', (event) ->
              event.stopPropagation()
              event.preventDefault()
              if event.currentTarget.id == 'next_lazy_img'
                box.animate {'left': -window.outerWidth*2}, ->
                  nextLink.click()
                  box.css({'left': window.outerWidth*2})
                  box.animate {'left': 0}
              else
                box.animate {'left': window.outerWidth*2}, ->
                  prevLink.click()
                  box.css({'left': -window.outerWidth*2})
                  box.animate {'left': 0}, 100
        $(img).attr({ 'class': 'lazy_img', src: href })
      else
        $.ajax({
          url: href,
          success: (data) => $.lazybox.show(data, options)
          error: () => $.lazybox.close() })

  init = (options) ->
    options = $.extend $.extend({}, defaults), $.lazybox.settings, options
    $('body:not(:has(#lazybox))').append(html)
    box = $('#lazybox')
    overlay = $('#lazy_overlay')
    close = $('#lazy_close')
    if options.klass then box.attr('class', options.klass) else box.removeClass()
    if options.onTop then overlay.attr('class', 'top') else overlay.removeClass()
    if options.close
      if options.closeImg then close.attr('class', 'img') else close.removeClass()
    else close.removeClass()
    if !options.modal and options.overlay
      overlay.bind 'click', () => $.lazybox.close()
    else
      overlay.unbind()
    $(document).keyup (e) ->
      $.lazybox.close() if e.keyCode == 27 and options.esc
    box.on 'click', '#lazy_close, .lazy_buttons a', (e) => $.lazybox.close(); e.preventDefault()
    return options

) jQuery
