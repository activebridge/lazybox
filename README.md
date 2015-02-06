LazyBox [![Build Status](https://travis-ci.org/activebridge/lazybox.png?branch=master)](https://travis-ci.org/galulex/lazybox) [![Gem Version](https://badge.fury.io/rb/lazybox.png)](http://badge.fury.io/rb/webhostinghub-glyphs-rails) [![endorse](http://api.coderwall.com/galulex/endorsecount.png)](http://coderwall.com/galulex)
=

[Live Demo](http://lazybox.herokuapp.com/)

[Demo Source](https://github.com/galulex/lazybox_demo)

Lazybox is a jQuery-based, lightbox that can display entire remote pages, images and confirmation dialogs.
Replace standard rails confirmations with lazybox just added several rows to your project. Use lazybox with rails assets pipeline.

LazyBox implemented using only css and jquery without images.
This is high perfomance modal dialogs. All unpacked files take only 5 kb.
This is simplest solution for popup windows and custom confirmation dialogs.

Upgrade to 1.1.0
-

After you upgrate the lazybox to 1.1.0 version you should add `render_lazybox` helper to your layout.

Installing
----------

Add it to your Gemfile:

```ruby
gem 'lazybox'
```

Then run `bundle install` to update your application's bundle.

Add to your layout helper `render_lazybox`:

```slim
  ...
    render_lazybox
  body
html
```

Include in your `application.css`:

```scss
 @include 'lazybox';
```

 There are a lot of variables you can customise:

```scss
$lazy-transition: .3s;
$lazy-z-index:    1000;
$lazy-overlay:    rgba(black, .7);
$lazy-bg:         white;
$lazy-border:     1px solid #ccc;
$lazy-shadow:     0 1px 5px #333;
$lazy-padding:    20px;
$lazy-start:      scale(.7);
$lazy-end:        scale(1);
$lazy-close:      '×';
```

Use `$lazy-start` and `$lazy-end` to contol the animation, `$lazy-close` to set close image.

You should set the variable before you include the `lazybox`

```scss
  $lazy-start:      rotate(180);
  $lazy-end:        rotate(0);
  $lazy-close:      url(url-to-image);

  @include 'lazybox';
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
$.lazybox("<div>It works!</div>",{modal: true, close: false})
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
  $('a[rel*=lazybox]').lazybox({esc: true, close: true, modal: true, klass: 'class'});
});
```

If there are more than one link to image you can click on image in the lazybox to show the next one (version < 0.2.6)

```haml
= link_to image.url, rel: :lazybox do
  = image_tag image.url, height: 100
= link_to image2.url, rel: :lazybox do
  = image_tag image2.url, height: 100
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

Display on page load
-

You can show lazybox with some content on page load. To do this you should `content_for` helper:

`index.haml`

```haml
content_for :lazybox do
  This text appears on page load
```


Options
-------

    esc:        true|false //default true.  Close lazybox on esc press
    close:      true|false //default true.  Show close lazybox button
    modal:      true|false //default true.  Close lazybox on overlay click
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

IE9 +
Chrome
Firefox
Opera
Safari

### If you want to support IE < 9 you have to use version 0.2.*.

Copyright© Alex Galushka
