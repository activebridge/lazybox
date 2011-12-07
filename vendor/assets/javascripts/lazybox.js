(function($){
  $.fn.lazybox = function(options){
    var defaults = {overlay: true, esc: true, close: true, modal: true, opacity: 0.3};
    var options = $.extend(defaults, options);

    this.live('click', function(e){
      e.preventDefault();
      if (options.overlay) {
        $('body:not(:has(#lazybox_overlay))').append("<div id='lazybox_overlay' style='display:none'></div>");
        $('#lazybox_overlay').css({filter: 'alpha(opacity='+options.opacity*100+')', opacity: options.opacity});
        $('#lazybox_overlay').fadeIn(500);
      }

      $.ajax({
        url: $(this).attr('href'),
        success: function(data){
          $('body:not(:has(#lazybox))').append("<div id='lazybox'><div id='lazybox_body'></div></div>");
          if (options.cssClass) { $('#lazybox').addClass(options.cssClass) } else { $('#lazybox').removeClass(); }
          if (options.close) {
            $('#lazybox:not(:has(#lazybox_close))').prepend($("<a id='lazybox_close' title='close'>×</a>"));
            if ($.browser.msie) $('#lazybox_close').addClass('ie');
          } else $('#lazybox_close').remove();
          $('#lazybox_body').html(data);
          center_lazybox();
          $('#lazybox').fadeIn(300);
          if (!options.modal) { $('#lazybox_overlay').bind('click', function(){ close_lazybox() }) } else { $('#lazybox_overlay').unbind(); }
          },
        error: function(){
          $('#lazybox_overlay').fadeOut(500);
        }
      });
    });

    if (options.close) $('#lazybox_close').live('click', function(){ close_lazybox() });
    if (!options.modal && options.overlay) { $('#lazybox_overlay').bind('click', function(){ close_lazybox() }) } else { $('#lazybox_overlay').unbind(); }
    $(document).keyup(function(e) { if (e.keyCode == 27 && options.esc) close_lazybox() });
  }

  function close_lazybox(){
    $('#lazybox').fadeOut(300);
    $('#lazybox_overlay').fadeOut(500);
  }

  function center_lazybox(){
    var x = (($(window).height() - $('#lazybox').outerHeight()) / 2) + $(window).scrollTop();
    $('#lazybox').css({ top: ((x < 0) ? 20 : x), left:(($(window).width() - $('#lazybox').outerWidth()) / 2) + $(window).scrollLeft() });
  }

  $(document).bind('close.lazybox', function(){ close_lazybox() });
})(jQuery);

