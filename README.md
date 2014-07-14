LazyBox [![Build Status](https://travis-ci.org/activebridge/lazybox.png?branch=master)](https://travis-ci.org/galulex/lazybox) [![Gem Version](https://badge.fury.io/rb/lazybox.png)](http://badge.fury.io/rb/webhostinghub-glyphs-rails) [![endorse](http://api.coderwall.com/galulex/endorsecount.png)](http://coderwall.com/galulex)
=

[Live Demo](http://lazybox.herokuapp.com/)

[Demo Source](https://github.com/galulex/lazybox_demo)

Lazybox is a jQuery-based, lightbox that can display entire remote pages, images and confirmation dialogs.
Replace standard rails confirmations with lazybox just added several rows to your project. Use lazybox with rails assets pipeline.

LazyBox implemented using only css and jquery without images.
This is high perfomance modal dialogs. All unpacked files take only 5 kb.
This is simplest solution for popup windows and custom confirmation dialogs.

Installing
----------

Add it to your Gemfile:

```ruby
gem 'lazybox'
```

Then run `bundle install` to update your application's bundle.

Include in your `application.css`:

```css
 *= require lazybox
```

And in `application.js`:

```javascript
//= require lazybox
```

Usage
-----

###Remote pages
Usual remote link:

```haml
- link_to 'Lazybox', new_model_path, remote: true
```

In your controller:

```ruby
def new
  @model = Model.new
end

def create
  @model = Model.new(params[:model])
  render action: :new unless @model.save
end
```

`new.js.haml`

```haml
$.lazybox("#{j(render partial: 'form')}");
```

`create.js.haml`

```haml
$.lazybox.close()
window.location.reload()
```

###Confirmations

You can replace standard rails confirmations with lazybox

And in `application.js`:

```javascript
$.rails.allowAction = $.lazybox.confirm;
```

for options use global lazybox settings:

```javascript
$.lazybox.settings = {cancelClass: "button gray", submitClass: 'button gray', overlay: false}
```

or instance settings

```javascript
$.lazybox("<div>It works!</div>",{onTop: true, opacity: 0.7, modal: false})
```

###Images

```haml
- link_to 'Image', image.url, rel: :lazybox
```
Include in your `app/assets/javascripts/application.js`:

```javascript
$(document).ready(function() {
  $('a[rel*=lazybox]').lazybox();
  // or with options
  $('a[rel*=lazybox]').lazybox({overlay: true, esc: true, close: true, modal: true, klass: 'class'});
});
```

If there are more than one link to image you can click on image in the lazybox to show the next one (version < 0.2.6)

```haml
= link_to image.url, rel: :lazybox do
  = image_tag image.url, height: 100
= link_to image2.url, rel: :lazybox do
  = image_tag image2.url, height: 100
```

Custom close image
------------------

Set 'closeImg' option to true.

`application.js`:

```javascript
$(document).ready(function() {
  $('.images a').lazybox({closeImg: true});
});
```

Style your close:

`application.css`

```css
#lazybox_close.img {
  background: url('close.png') no-repeat;
  width: 32px;
  height: 32px;
  top: -17px;
  right: -17px;
}
```

We can use lazybox with `turbolinks` to show page loading spinner:

```coffeescript
  $(document).on 'page:fetch', -> $.lazybox("<i class='icon-orange'></i>", { klass: 'spinner', close: false, esc: false })
```

```css
#lazybox.spinner {
  background: transparent;
  border: none;
  box-shadow: none;
}
```

Turbolinks spinner
------------------

```coffee
  $(document).on 'page:fetch', -> $.lazybox("<i class='fa fa-spinner fa-spin'>", { klass: 'spinner', close: false, esc: false })
  $(document).on 'page:change', -> $.lazybox.close()
```

```scss
  #lazybox.spinner {
    background: transparent;
    box-shadow: none;
    .fa-spinner { font-size: 128px; }
  }
```

Options
-------

    esc:        true|false //default true.  Close lazybox on esc press
    close:      true|false //default true.  Show close lazybox button
    modal:      true|false //default true.  Close lazybox on overlay click
    closeImg:   true|false //default false. Use image for close link
    onTop:      true|false //default false. Show lazybox on top instead of on center. It will use slide animation instead of fade.
    klass:      'class'                     Set class for lazybox. <div id='lazybox' class='class'>...</div>
    //confirmation options
    cancelText:   //default 'Cancel'. Cancel button text
    submitText:   //default 'Ok'.     Confirm button text
    cancelClass:  //default 'button'. Cancel button class
    submitClass:  //default 'button'. Confirm button class

Events
------

    $.lazybox.show()
    $.lazybox.close()

Browser Compatibility
---------------------

IE10 +
Chrome
Firefox
Opera
Safari

### If you want to support IE < 9 you have to use version 0.2.*.

Copyright© Alex Galushka
