(function($){
  $.fn.lazybox = function(options){
    var defaults = {overlay: true, esc: true, close: true, modal: true, opacity: 0.3};
    var options = $.extend(defaults, options);
    var imagesRegexp = new RegExp('\\.(png|jpg|jpeg|gif)(\\?.*)?$', 'i')
    this.live('click', function(e){
      var href = $(this).attr('href');
      e.preventDefault();
      $('body:not(:has(#lazybox))').append("<div id='lazybox'><div id='lazybox_body'></div></div>");
      apply_settings(options);
      if (href.match(imagesRegexp)) {
        var img = new Image()
        img.onload = function() {
          $('#lazybox_body').html('<img src="' + img.src + '" /></div>');
          center_lazybox();
          $('#lazybox').fadeIn(300);
        }
        img.src = href
      } else {
        $.ajax({
          url: href,
          success: function(data){
            $('#lazybox_body').html(data);
            center_lazybox();
            $('#lazybox').fadeIn(300);
            },
          error: function(){
            $('#lazybox_overlay').fadeOut(500);
          }
        });
      }
    });
  }

  function close_lazybox(){
    $('#lazybox').fadeOut(300);
    $('#lazybox_overlay').fadeOut(500);
  }

  function center_lazybox(){
    var x = (($(window).height() - $('#lazybox').outerHeight()) / 2) + $(window).scrollTop();
    $('#lazybox').css({ top: ((x < 0) ? 20 : x), left:(($(window).width() - $('#lazybox').outerWidth()) / 2) + $(window).scrollLeft() });
  }

  function apply_settings(options){
    if (options.overlay) {
      $('body:not(:has(#lazybox_overlay))').append("<div id='lazybox_overlay'></div>");
      $('#lazybox_overlay').css({filter: 'alpha(opacity='+options.opacity*100+')', opacity: options.opacity});
      $('#lazybox_overlay').fadeIn(500);
    }
    if (options.cssClass) { $('#lazybox').addClass(options.cssClass) } else { $('#lazybox').removeClass(); }
    if (options.close) {
      $('#lazybox:not(:has(#lazybox_close))').prepend($("<a id='lazybox_close' title='close'>×</a>"));
      $('#lazybox_close').live('click', function(){ close_lazybox() });
      if ($.browser.msie) $('#lazybox_close').addClass('ie');
    } else $('#lazybox_close').remove();
    if (!options.modal) { $('#lazybox_overlay').bind('click', function(){ close_lazybox() }) } else { $('#lazybox_overlay').unbind(); }
    if (!options.modal && options.overlay) { $('#lazybox_overlay').bind('click', function(){ close_lazybox() }) } else { $('#lazybox_overlay').unbind(); }
    $(document).keyup(function(e) { if (e.keyCode == 27 && options.esc) close_lazybox() });
  }

  $(document).bind('close.lazybox', function(){ close_lazybox() });
})(jQuery);
