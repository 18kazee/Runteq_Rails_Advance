require 'rails_helper'

RSpec.describe 'AdminArticleEyeCatch', type: :system do
  let!(:article) { create :article }
  let(:admin) { create :user, :admin }

  before do
    login(admin)
    visit admin_articles_path
    click_link '編集', href: edit_admin_article_path(article.uuid)
    click_button '更新する'
    attach_file 'article[eye_catch]', "#{Rails.root}/spec/fixtures/images/sample.png"
  end

  describe 'アイキャッチの幅を変更する' do
    context '幅を100~700pxに変更した場合' do
      it '記事の更新に成功し、プレビューが表示されること' do
        eyecatch_width = rand(100..700)
        fill_in 'article[eyecatch_width]', with: eyecatch_width
        click_button '更新する'
        expect(page).to have_content('更新しました')
        click_link('プレビュー')
        switch_to_window(windows.last)
        expect(page).to have_css('.eye_catch'), 'プレビューページにeye_catchクラスが存在しません'
        expect(current_path).to eq(admin_article_preview_path(article.uuid)), '編集した記事のページに遷移していません'
        expect(page).to have_selector("img[src$='sample.png']"), 'プレビューページに画像が表示されていません'
      end
    end
    context '幅を0~99pxに変更した場合' do
      it '記事の更新に失敗しすること' do
        eyecatch_width = rand(0..99)
        fill_in 'article[eyecatch_width]', with: eyecatch_width
        click_button '更新する'
        expect(page).not_to have_content('更新しました'), '横幅のバリデーションが正しく設定されていません'
        expect(page).to have_content('は100以上の値にしてください'), 'エラーメッセージが正しく表示されていません'
      end
    end
    context '幅を701~9999pxに変更した場合' do
      it '記事の更新に失敗しすること' do
        eyecatch_width = rand(701..9999)
        fill_in 'article[eyecatch_width]', with: eyecatch_width
        click_button '更新する'
        expect(page).not_to have_content('更新しました'), '横幅のバリデーションが正しく設定されていません'
        expect(page).to have_content('は700以下の値にしてください'), 'エラーメッセージが正しく表示されていません'
      end
    end
  end

  describe 'アイキャッチの位置を変更' do
    context '左寄せに表示されること' do
      it 'アイキャッチが左寄せに表示されること' do
        choose '左寄せ'
        click_on '更新する'
        click_on 'プレビュー'
        switch_to_window(windows.last)
        expect(page).to have_selector('section.eye_catch.text-left'), 'アイキャッチが左寄せに表示されていません'
      end
    end
    context '中央に表示されること' do
      it 'アイキャッチが中央に表示されること' do
        choose '中央'
        click_on '更新する'
        click_on 'プレビュー'
        switch_to_window(windows.last)
        expect(page).to have_selector('section.eye_catch.text-center'), 'アイキャッチが中央に表示されていません'
      end
    end
    context '右寄せに表示されること' do
      it 'アイキャッチが右寄せに表示されること' do
        choose '右寄せ'
        click_on '更新する'
        click_on 'プレビュー'
        switch_to_window(windows.last)
        expect(page).to have_selector('section.eye_catch.text-right'), 'アイキャッチが右寄せに表示されていません'
      end
    end
  end
end
