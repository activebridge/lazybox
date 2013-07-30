( ($) ->
  defaults = {
    overlay: true,
    esc: true,
    close: true,
    modal: true,
    opacity: 0.3,
    speed: 300,
    fixed: false,
    top: '49%',
    cancelText: 'Cancel',
    cancelClass: 'button',
    submitText: 'Ok',
    submitClass: 'button'
  }

  html = "<div id='lazybox'><div id='lazybox_body'></div></div>"
  box = $('#lazybox')
  overlay = $('#lazybox_overlay')
  close = $('#lazybox_close')

  $.lazybox = (html, options) -> $.lazybox.show(html, options)

  $.extend $.lazybox,
    settings: $.extend {}, defaults

    show: (content, options) ->
      options = init(options)
      $('#lazybox_body').html(content)
      $.lazybox.center(options.fixed, options.top)
      effect = if options.top == 0 then 'slideDown' else 'fadeIn'
      box[effect](options.speed)
      return options

    close: (speed) ->
      speed = speed || defaults.speed
      effect = if (box.position().top - window.scrollY == 0) then 'slideUp' else 'fadeOut'
      box[effect](speed)
      overlay.fadeOut(speed+200)

    center: (fixed, top) =>
      if fixed
        box.css({'z-index': 100000, 'margin-left': -box.outerWidth()/2, 'margin-top': top, top: 0, position: 'fixed', left: '49%'})
      else
        box.css({'z-index': 100000, top: top, left:(($(window).width()-box.outerWidth())/2)+$(window).scrollLeft(), position: 'absolute', margin: 0})

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
            $('#lazybox_body:not(:has(a#next_lazy_img))').append("<a id='prev_lazy_img' href=''><b>‹</b></a><a id='next_lazy_img' href=''><b>›</b></a>")
            $('#next_lazy_img, #prev_lazy_img').bind 'click', (event) ->
              event.preventDefault()
              box.fadeOut options.speed, () ->
                if event.currentTarget.id == 'next_lazy_img' then nextLink.click() else prevLink.click()
        $(img).attr({ 'class': 'lazy_img', src: href })
      else
        $.ajax({
          url: href,
          success: (data) => $.lazybox.show(data, options)
          error: () => $.lazybox.close(options.speed) })

  init = (options) ->
    options = $.extend $.extend({}, defaults), $.lazybox.settings, options
    if options.overlay
      $('body:not(:has(#lazybox_overlay))').append("<div id='lazybox_overlay'></div>")
      overlay = $('#lazybox_overlay')
      overlay.css({ filter: 'alpha(opacity='+options.opacity*100+')', opacity: options.opacity }).fadeIn(options.speed+200)
    $('body:not(:has(#lazybox))').append(html)
    box = $('#lazybox')
    if options.klass then box.attr('class', options.klass) else box.removeClass()
    if options.close
      box.not(':has(#lazybox_close)').prepend($("<a id='lazybox_close' title='close'></a>"))
      close = $('#lazybox_close')
      if options.closeImg then close.attr('class', 'img').text('') else close.removeClass().text('×')
    else close.remove()
    if !options.modal and options.overlay
      overlay.bind 'click', () => $.lazybox.close(options.speed)
    else
      overlay.unbind()
    $(document).keyup (e) ->
      $.lazybox.close(options.speed) if e.keyCode == 27 and options.esc
    box.on 'click', '#lazybox_close, .lazy_buttons a', (e) => $.lazybox.close(options.speed); e.preventDefault()
    return options

) jQuery
