describe 'lazybox', ->

  describe 'settings', ->
    it 'should set global settings', ->
      $.lazybox.settings = {close: true}
      expect($.lazybox.settings).toEqual({close: true})

    it 'should get global settings', ->
      expect($.lazybox.settings).toBeDefined()

  describe 'show', ->
    it 'should show lazybox', ->
      $.lazybox.show('')
      expect($('#lazybox')).toBeVisible

    it 'should contain lazybox_body', ->
      $.lazybox.show('')
      expect($('#lazybox')).toContain('#lazybox_body')

    it 'should contain lazybox_body with passed html', ->
      $.lazybox.show('<div>test</div>')
      expect($('#lazybox_body')).toHaveHtml('<div>test</div>')

  describe 'close', ->
    it 'should hide lazybox', ->
      $.lazybox('')
      $.lazybox.close()
      expect($('#lazybox')).toBeHidden

    it 'should hide lazybox overlay', ->
      $.lazybox('')
      $.lazybox.close()
      expect($('#lazybox_overlay')).toBeHidden

  describe 'confirm', ->
    it 'should return true if data-confirm is no specified', ->
      element = $('<a href="">×</a>')
      expect($.lazybox.confirm(element)).toBeTruthy()

    element = $('<a href="" data-confirm="×">×</a>')

    it 'should return false if data-confirm is specified', ->
      expect($.lazybox.confirm(element)).toBeFalsy()

    it 'should show lazybox', ->
      $.lazybox.confirm(element)
      expect($('#lazybox')).toBeVisible()

    it 'should have text specified in data-confirm attribute', ->
      $.lazybox.confirm(element)
      expect($('#lazybox p')).toHaveText(element.data('confirm'))

    it 'should contain buttons', ->
      $.lazybox.confirm(element)
      expect($('#lazybox_body')).toContain('.lazy_buttons')

    it 'should have confirm class', ->
      $.lazybox.confirm(element)
      expect($('#lazybox')).toHaveClass('confirm')

    it 'should have confirm button with class specified in settings', ->
      $.lazybox.settings = { submitClass: 'ok', submitText: 'ok' }
      $.lazybox.confirm(element)
      expect($('#lazybox .lazy_buttons')).toContain('.ok')

    it 'should have confirm button with text specified in settings', ->
      $.lazybox.settings = { submitClass: 'ok', submitText: 'ok' }
      $.lazybox.confirm(element)
      expect($('#lazybox .lazy_buttons a.ok')).toHaveText('ok')

    it 'should have cancel button with class specified in settings', ->
      $.lazybox.settings = { cancelClass: 'cancel', cancelText: 'cancel' }
      $.lazybox.confirm(element)
      expect($('#lazybox .lazy_buttons')).toContain('.cancel')

    it 'should have cancel button with class specified in settings', ->
      $.lazybox.settings = { cancelClass: 'cancel', cancelText: 'cancel' }
      $.lazybox.confirm(element)
      expect($('#lazybox .lazy_buttons a.cancel')).toHaveText('cancel')

  describe 'init', ->

    describe 'overlay element', ->
      it 'should exist', ->
        $.lazybox('')
        expect($('body')).toContain('#lazybox_overlay')

      it 'should be visible', ->
        $.lazybox('')
        expect($('#lazybox_overlay')).toBeVisible()

    describe 'lazybox element', ->
      it 'should have class specified in params', ->
        $.lazybox('', { klass: 'test' })
        expect($('#lazybox')).toHaveClass('test')

      it 'should not have any class if it is not specified', ->
        $.lazybox('', { klass: 'test' })
        $.lazybox('')
        expect($('#lazybox')).not.toHaveClass('test')

    describe 'close element', ->
      it 'should exist', ->
        $.lazybox('')
        expect($('#lazybox')).toContain('#lazybox_close')

      it 'should contain text', ->
        $.lazybox('')
        expect($('#lazybox_close')).toHaveText('×')

      it 'should not contain text', ->
        $.lazybox('', { closeImg: true })
        expect($('#lazybox_close')).not.toHaveText('×')

      it 'should have img class', ->
        $.lazybox('', { closeImg: true })
        expect($('#lazybox_close')).toHaveClass('img')

      it 'should have close event binded', ->
        $('#lazybox_close').click()
        expect($('#lazybox')).toBeHidden()

      it 'should not exist', ->
        $.lazybox('', { close: false })
        expect($('#lazybox')).not.toContain('#lazybox_close')
