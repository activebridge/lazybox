(function($){
  $.fn.extend({
    lazybox: function(options) {
      this.live('click', function(e){
        e.preventDefault();
        c = ($.browser.msie) ? ' class="ie" ' : '';
        $('body:not(:has(#lazybox_overlay))').append("<div id='lazybox_overlay' style='display:none'></div>");
        $('#lazybox_overlay').fadeIn(500);
        $.ajax({
          url: $(this).attr('href'),
          success: function(data){
            $('body:not(:has(#lazybox))').append("<div id='lazybox' style=''><a id='lazybox_close'"+c+" title='close'>×</a><div id='lazybox_body'></div></div>");
            $('#lazybox_body').html(data);
            $('#lazybox').fadeIn(300, function(){
              var x = (($(window).height() - $(this).outerHeight()) / 2) + $(window).scrollTop();
              $(this).css({
                top: ((x < 0) ? 20 : x),
                left:(($(window).width() - $(this).outerWidth()) / 2) + $(window).scrollLeft()
              });
            });
          },
          error: function(){
            $('#lazybox_overlay').fadeOut(500);
          }
        });
      });
    }
  });
})(jQuery);

$('#lazybox_close').live('click', function(){
  $('#lazybox').fadeOut(300);
  $('#lazybox_overlay').fadeOut(500);
});

