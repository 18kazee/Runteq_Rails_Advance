require 'Rails_helper'

RSpec.describe 'AdminArticleEmbeddedMedia', type: :system do
  let(:admin) { create(:user, :admin) }
  let(:article) { create(:article) }

  describe '記事の埋め込みブロックを作成' do
    before do
      login(admin)
      article
      visit edit_admin_article_path(article.uuid)
      click_on('ブロックを追加する')
      click_on('埋め込み')
      click_on('編集')
    end
    context 'Youtubeを選択した場合' do
      it 'プレビューした記事にyoutubeが埋め込まれていること', js: true do
        select 'YouTube', from: 'embed[embed_type]' 
        fill_in 'ID', with: 'https://youtu.be/Eg8i97Vjpxs'
        page.all('.box-footer')[0].click_button('更新する')
        click_on('プレビュー')
        switch_to_window(windows.last)
        expect(current_path).to eq(admin_article_preview_path(article.uuid)), '更新した画面をプレビューできていません'
        expect(page).to have_selector("iframe[src='https://www.youtube.com/embed/Eg8i97Vjpxs']"), 'Youtubeが埋め込まれていません'
      end
    end
    context 'Twitterを選択した場合' do
      it 'プレビューした記事にTwitterが埋め込まれていること', js: true do
        select 'Twitter', from: 'embed[embed_type]'
        fill_in 'ID', with: 'https://twitter.com/hisaju01/status/1600280172825313281'
        page.all('.box-footer')[0].click_button('更新する')
        sleep 1
        click_on('プレビュー')
        switch_to_window(windows.last)
        expect(current_path).to eq(admin_article_preview_path(article.uuid)), '更新した画面をプレビューできていません'
        sleep 2
        expect(page).to have_selector(".twitter-tweet"), 'Twitterが埋め込まれていません'
      end
    end
  end
end
