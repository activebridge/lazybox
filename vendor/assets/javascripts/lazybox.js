(function($){
  var defaults = {overlay: true, esc: true, close: true, niceClose: true, modal: true, opacity: 0.3, onTop: false, cancelText: 'Cancel', cancelClass: 'button', submitText: 'Ok', submitClass: 'button', speed: 300}, effect, y
  $.lazybox = function(html, options){ $.lazybox.show(html, options) }
  $.extend($.lazybox, {
    settings: $.extend({}, defaults),
    show: function(content, options){
            var options = init(options)
            $('#lazybox_body').html(content)
            $.lazybox.center(options.onTop);
            (options.onTop) ? effect = 'slideDown' : effect = 'fadeIn'
            $('#lazybox')[effect](options.speed)
            return options
          },
    close: function(speed){
             speed = speed || defaults.speed;
             ($('#lazybox').position().top == 0) ? effect = 'slideUp' : effect = 'fadeOut'
             $('#lazybox')[effect](speed)
             $('#lazybox_overlay').fadeOut(speed+200)
           },
    center: function(onTop){
              (onTop) ? y = 0 : y = (($(window).height()-$('#lazybox').outerHeight())/2)+$(window).scrollTop()
              $('#lazybox').css({ top: ((y < 20 && !onTop) ? 20 : y), left:(($(window).width()-$('#lazybox').outerWidth())/2)+$(window).scrollLeft()})
            },
    confirm: function(element){
               var options = $.extend(defaults, $.lazybox.settings)
               var message = element.data('confirm')
               if (!message) return true
               $.lazybox.show('<p>'+message+'</p><div class="lazy_buttons"><div>', {klass: 'confirm'})
               element.clone().attr('class', options.submitClass).removeAttr('data-confirm').text(options.submitText).appendTo('.lazy_buttons')
               $('.lazy_buttons').append(' ')
               $('<a>', {href: '', text: options.cancelText, 'class': options.cancelClass}).appendTo('.lazy_buttons')
             }
  });
  $.fn.lazybox = function(options){
    this.live('click', function(e){
      var a = $(this), href = a.attr('href'), imagesRegexp = new RegExp('\\.(png|jpg|jpeg|gif)(\\?.*)?$', 'i')
      e.preventDefault()
      if (href.match(imagesRegexp)){
        var img = new Image(), nextLink
        img.onload = function(element){
          options = $.lazybox.show(img, options);
          (a.is(':last-child')) ? nextLink = a.siblings('a[rel*=lazybox]:first') : nextLink = a.next('a[rel*=lazybox]:first')
          if (!nextLink.length == 0) $('#lazybox img').bind('click', function(){ $('#lazybox').fadeOut(options.speed, function(){ nextLink.click() }) })
        }
        $(img).attr({'class': 'lazy_img', src: href})
      } else $.ajax({url: href, success: function(data){ $.lazybox.show(data, options) }, error: function(){ $.lazybox.close(300) }})
    });
  }

  function init(options){
    var options = $.extend($.extend({}, defaults), $.lazybox.settings, options)
    if (options.overlay) {
      $('body:not(:has(#lazybox_overlay))').append("<div id='lazybox_overlay'></div>")
      $('#lazybox_overlay').css({filter: 'alpha(opacity='+options.opacity*100+')', opacity: options.opacity}).fadeIn(options.speed+200)
    }
    $('body:not(:has(#lazybox))').append("<div id='lazybox'><div id='lazybox_body'></div></div>");
    (options.klass) ? $('#lazybox').attr('class', options.klass) : $('#lazybox').removeClass()
    if (options.close) {
      $('#lazybox:not(:has(#lazybox_close))').prepend($("<a id='lazybox_close' title='close'></a>"));
      (options.closeImg) ? $('#lazybox_close').attr('class', 'img').text('') : $('#lazybox_close').removeClass().text('×')
      if (!$.browser.msie && options.niceClose && !options.closeImg && !options.onTop) $('#lazybox_close').attr('class', 'nice')
    } else $('#lazybox_close').remove();
    (!options.modal && options.overlay) ? $('#lazybox_overlay').bind('click', function(){ $.lazybox.close(options.speed) }) : $('#lazybox_overlay').unbind()
    $(document).keyup(function(e) { if (e.keyCode == 27 && options.esc) $.lazybox.close(options.speed) })
    $('#lazybox_close, #lazybox_body .lazy_buttons a').live('click', function(e){ $.lazybox.close(options.speed); e.preventDefault() })
    return options
  }

})(jQuery);
