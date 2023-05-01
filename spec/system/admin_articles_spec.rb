require 'rails_helper'

RSpec.describe 'AdimnArticles', type: :system do
  let(:admin) { create :user, :admin }
  let(:future_article) { create :article, :future }
  let(:past_article) { create :article, :past }
  let(:draft_article) { create :article, :draft}
  before do
    login(admin)
  end
  describe '記事の編集画面' do
    context '記事のステータスを「公開」または「公開待ち」、公開日時を「未来の日付」に設定して、「更新する」ボタンを押した場合' do
      it '記事のステータスを「公開待ち」に変更して「更新しました」というフラッシュメッセージが表示されること' do
        visit edit_admin_article_path(past_article.uuid)
        fill_in '公開日', with: DateTime.now.tomorrow
        click_on '更新する'
        expect(page).to have_content('更新しました'), '「更新しました」というメッセージが表示されていません'
        expect(page).to have_select('状態', selected: '公開待ち'), 'ステータスが「公開待ち」になっていません'
      end
    end
    context '記事のステータスを「公開」または「公開待ち」、公開日時を「過去の日付」に設定して、「更新する」ボタンを押した場合' do
      it '記事のステータスを「公開」に変更して「更新しました」というフラッシュメッセージが表示されること' do
        visit edit_admin_article_path(future_article.uuid)
        fill_in '公開日', with: DateTime.now.yesterday
        click_on '更新する'
        expect(page).to have_content('更新しました'), '「更新しました」というメッセージが表示されていません'
        expect(page).to have_select('状態', selected: '公開'), 'ステータスが「公開」になっていません'
      end
    end
    context '記事のステータスを「下書き」のまま、「更新する」ボタンを押した場合' do
      it '記事のステータスは「下書き」のまま「更新しました」とフラッシュメッセージが表示されること' do
        visit edit_admin_article_path(draft_article.uuid)
        click_on '更新する'
        expect(page).to have_content('更新しました'), '「更新しました」というメッセージが表示されていません'
        expect(page).to have_selector(:css, '.form-control', text: '下書き'), 'ステータスが下書きになっていません'
      end
    end
    context '公開日時が「未来の日付」となっている記事に対して、「公開する」ボタンを押した場合' do
      it '記事のステータスを「公開待ち」に変更して「公開待ちにしました」とフラッシュメッセージが表示されること' do
        visit edit_admin_article_path(past_article.uuid)
        fill_in '公開日', with: DateTime.now.tomorrow
        click_on '更新する'
        click_on '公開する'
        expect(page).to have_content('記事を公開待ちにしました'), '「公開待ちにしました」というメッセージが表示されていません'
        expect(page).to have_select('状態', selected: '公開待ち'), 'ステータスが「公開待ち」になっていません'
      end
    end
    context '公開日時が「過去の日付」となっている記事に対して、「公開する」ボタンを押した場合' do
      it '記事のステータスを「公開」に変更して「公開しました」とフラッシュメッセージが表示される' do
        visit edit_admin_article_path(future_article.uuid)
        fill_in '公開日', with: DateTime.now.yesterday
        click_on '更新する'
        click_on '公開する'
        expect(page).to have_content('記事を公開しました'), '「記事を公開しました」というメッセージが表示されていません'
        expect(page).to have_select('状態', selected: '公開'), 'ステータスが「公開」になっていません'
      end
    end
  end
end
