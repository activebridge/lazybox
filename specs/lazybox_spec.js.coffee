describe 'lazybox', ->

  describe 'settings', ->
    it 'sets global settings', ->
      $.lazybox.settings = {close: true}
      expect($.lazybox.settings).toEqual({close: true})

    it 'gets global settings', ->
      expect($.lazybox.settings).toBeDefined()

  describe 'show', ->
    it 'shows lazybox', ->
      $.lazybox.show('')
      expect($('#lazybox')).toBeVisible

    it 'contains lazy_body', ->
      $.lazybox.show('')
      expect($('#lazybox')).toContain('#lazy_body')

    it 'contains lazybox_body with passed html', ->
      $.lazybox.show('<div>test</div>')
      expect($('#lazy_body')).toHaveHtml('<div>test</div>')

  describe 'close', ->
    it 'should hide lazybox', ->
      $.lazybox('')
      $.lazybox.close()
      expect($('#lazybox')).toBeHidden

    it 'hides lazybox overlay', ->
      $.lazybox('')
      $.lazybox.close()
      expect($('#lazy_overlay')).toBeHidden

  describe 'confirm', ->
    it 'returns true if data-confirm is no specified', ->
      element = $('<a href="">×</a>')
      expect($.lazybox.confirm(element)).toBeTruthy()

    element = $('<a href="" data-confirm="×">×</a>')

    it 'returns false if data-confirm is specified', ->
      expect($.lazybox.confirm(element)).toBeFalsy()

    it 'shows lazybox', ->
      $.lazybox.confirm(element)
      expect($('#lazybox')).toBeVisible()

    it 'has text specified in data-confirm attribute', ->
      $.lazybox.confirm(element)
      expect($('#lazybox p')).toHaveText(element.data('confirm'))

    it 'contains buttons', ->
      $.lazybox.confirm(element)
      expect($('#lazy_body')).toContain('.lazy_buttons')

    it 'has confirm class', ->
      $.lazybox.confirm(element)
      expect($('#lazybox')).toHaveClass('confirm')

    it 'has confirm button with class specified in settings', ->
      $.lazybox.settings = { submitClass: 'ok', submitText: 'ok' }
      $.lazybox.confirm(element)
      expect($('#lazybox .lazy_buttons')).toContain('.ok')

    it 'has confirm button with text specified in settings', ->
      $.lazybox.settings = { submitClass: 'ok', submitText: 'ok' }
      $.lazybox.confirm(element)
      expect($('#lazybox .lazy_buttons a.ok')).toHaveText('ok')

    it 'has cancel button with class specified in settings', ->
      $.lazybox.settings = { cancelClass: 'cancel', cancelText: 'cancel' }
      $.lazybox.confirm(element)
      expect($('#lazybox .lazy_buttons')).toContain('.cancel')

    it 'has cancel button with class specified in settings', ->
      $.lazybox.settings = { cancelClass: 'cancel', cancelText: 'cancel' }
      $.lazybox.confirm(element)
      expect($('#lazybox .lazy_buttons a.cancel')).toHaveText('cancel')

  describe 'init', ->

    describe 'overlay element', ->
      it 'exists', ->
        $.lazybox('')
        expect($('body')).toContain('#lazy_overlay')

      it 'is visible', ->
        $.lazybox('')
        expect($('#lazy_overlay')).toBeVisible()

    describe 'lazybox element', ->
      it 'should have class specified in params', ->
        $.lazybox('', { klass: 'test' })
        expect($('#lazybox')).toHaveClass('test')

      it 'does not have any class if it is not specified', ->
        $.lazybox('', { klass: 'test' })
        $.lazybox('')
        expect($('#lazybox')).not.toHaveClass('test')

    describe 'close element', ->
      it 'should exist', ->
        $.lazybox('')
        expect($('#lazybox')).toContain('#lazy_close')

      it 'has img class', ->
        $.lazybox('', { closeImg: true })
        expect($('#lazy_close')).toHaveClass('img')

      it 'has close event binded', ->
        $('#lazy_close').click()
        expect($('#lazy_overlay')).not.toHaveClass('visible')

      it 'is hidden', ->
        $.lazybox('', { close: false })
        expect($('#lazy_close')).toBeHidden()
