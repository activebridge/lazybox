# LazyBox

Lazybox is a jQuery-based, lightbox which can display entire remote pages.
Use lazybox with rails 3.1 asset pipeline.

LazyBox implemented using only with css and jquery without images.
This is hight perfomance modal dialogs. All unpacked files take only 2.5 kb.
You never find simplest solution for popup windows.

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
      $('a#lazybox_close').click();
      window.location.reload();

#

Copyright© Alex Galushka
