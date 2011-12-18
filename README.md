# LazyBox

Lazybox is a jQuery-based, lightbox that can display entire remote pages and images.
Use lazybox with rails 3.1 assets pipeline.

LazyBox implemented using only css and jquery without images.
This is high perfomance modal dialogs. All unpacked files take only 4 kb.
This is simplest solution for popup windows.

# Installation

Add it to your Gemfile:

    gem 'lazybox'

Then run `bundle install` to update your application's bundle.

Include in your `app/assets/stylesheets/application.css`:

    /*
     * ...
     *= require lazybox
     * ...
     */

And in `app/assets/javascripts/application.js`:

    //= require lazybox

# Usage

Include in your `app/assets/javascripts/application.js`:

    $(document).ready(function() {
      $('a[rel*=lazybox]').lazybox();
      // or with options
      $('a[rel*=lazybox]').lazybox({overlay: true, esc: true, close: true, modal: true, opacity: 0.3, cssClass: 'class'});
    });

In your view:

    link_to 'Lazybox', new_model_path, :rel => :lazybox

In your controller:

    def new
      @model = Model.new
      respond_to do |format|
        format.js { render :layout => false }
      end
    end

    def create
      @model = Model.create(params[:model])
    end

or you can set before_filter that will disable layout for ajax requests:

    before_filter proc { |controller| (controller.action_has_layout = false) if controller.request.xhr? }

    def new
      @model = Model.new
    end

    def create
      @model = Model.create(params[:model])
    end

`create.js.haml`

    - if @model.errors.any?
      $('#lazybox_body').html("#{escape_javascript(render :partial => 'form')}");
    - else
      $(document).trigger('close.lazybox')
      window.location.reload();

you can use lazybox for displaing images

    - link_to 'Image', image.url, :rel => :lazybox

# Options

    overlay:  true|false //default true. Show lazybox overlay.
    esc:      true|false //default true. Close lazybox on esc press.
    close:    true|false //default true. Show close lazybox button.
    modal:    true|false //default true. Close lazybox on overlay click.
    opacity:  0.6 //default 0.3. Set opacity for lazybox overlay.
    cssClass:    'class' // Set class for lazybox. <div id='lazybox' class='class'>...</div>

# Events

    $(document).trigger('close.lazybox')

#

Copyright© Alex Galushka
