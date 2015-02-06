(($) ->
  defaults =
    esc: true
    close: true
    modal: false
    klass: ''
    cancelText: 'Cancel'
    cancelClass: 'btn'
    submitText: 'Ok'
    submitClass: 'btn'

  $.lazybox = (html, options) -> $.lazybox.show(html, options)

  $.extend $.lazybox,
    settings: $.extend {}, defaults

    show: (content, options) ->
      options = init(options)
      $('#lazy_body').html(content)
      $('#lazy_overlay').addClass('active')

    close: -> $('#lazy_overlay').removeClass()

    confirm: (element) ->
      options = $.extend defaults, $.lazybox.settings
      message = element.data('confirm')
      return true unless message
      $.lazybox.show('<p>'+message+'</p><div class="lazy_buttons"></div>', { klass: 'confirm' })
      element.clone().attr('class', options.submitClass).removeAttr('data-confirm').text(options.submitText).appendTo('.lazy_buttons')
      $('.lazy_buttons').append(' ')
      $('<button>', { text: options.cancelText, 'class': 'cancel ' + options.cancelClass }).appendTo('.lazy_buttons')
      return false

  $.fn.lazybox = (options) ->
    $(document).on 'click', @.selector, (e) ->
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
    $('#lazybox').attr('class', options.klass)
    $('#lazy_close').toggleClass('visible', options.close)
    $(document).on 'click', '#lazy_overlay', (e) ->
      $.lazybox.close() if !options.modal && e.target == $('#lazy_overlay')[0]
    $(document).on 'keyup.lazy', (e) ->
      if e.keyCode == 27 and options.esc
        $.lazybox.close()
        $(document).off('keyup.lazy')
    return options

) jQuery

$(document).on 'click', '#lazy_close, .lazy_buttons .cancel', $.lazybox.close
