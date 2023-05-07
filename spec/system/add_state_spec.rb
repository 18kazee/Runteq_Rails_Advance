require 'rails_helper'

RSpec.describe 'Add State', type: :system do
  let(:user) { create(:user) }
  let(:article) { create :article }

  before do
    login(user)
    visit admin_articles_path
    click_on '編集'
    attach_file 'article[eye_catch]', "#{Rails.root}/spec/fixtures/sample.png"
    click_on '更新する'
  end

  describe 'アイキャッチの幅を変更する' do
    context '幅を100~700pxに変更した場合' do
      it '記事の更新に成功し、プレビューが表示されること' do
        eyecatch_width = rand(100..700)
        fill_in 'article[eyecatch_width]', with: eyecatch_width
        click_on '更新する'
        click_on 'プレビュー'
        switch_to_window(windows.last)
        expect(page).to have_css('.eye_catch')
        expect(page).to have_selector("img[src$='sample.png']")
      end
    end
  end

  descraibe 'アイキャッチの位置' do
    it '左寄せにした場合、正常に左寄せに表示されること' do
      choose '左寄せ'
      click_on '更新する'
      click_on 'プレビュー'
      switch_to_window(windows.last)
      expect(page).to have selector('section.eye_catch.text-left')
    end
  end
