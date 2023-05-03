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
    describe '検索機能' do
      let(:article_with_author) { create(:article, :with_author, author_name: '田中') }
      let(:article_with_another_author) { create(:article, :with_author, author_name: '鈴木') }
      let(:article_with_tag) { create(:article, :with_tag, tag_name: 'Ruby') }
      let(:article_with_another_tag) { create(:article, :with_tag, tag_name: 'Rails') }
      let(:draft_article_with_sentence) { create(:article, :draft, :with_sentence, sentence_body: '基礎編アプリの記事') }
      let(:past_article_with_sentence) { create(:article, :past, :with_sentence, sentence_body: '基礎編アプリの記事') }
      let(:future_article_with_sentence) { create(:article, :future, :with_sentence, sentence_body: '基礎編アプリの記事') }
      let(:draft_article_with_another_sentence) { create(:article, :draft, :with_sentence, sentence_body: '応用編アプリの記事') }
      let(:past_article_with_another_sentence) { create(:article, :past, :with_sentence, sentence_body: '応用編アプリの記事') }
      let(:future_article_with_another_sentence) { create(:article, :future, :with_sentence, sentence_body: '応用編アプリの記事') }

      it '著者名で検索できること' do
        article_with_author
        article_with_another_author
        visit admin_articles_path
        within 'select[name="q[author_id]"]' do
          select '田中'
        end
        click_button '検索'
        expect(page).to have_content(article_with_author.title), '著者名で検索ができていません'
        expect(page).not_to have_content(article_with_another_author.title), '著者名での絞り込みができていません'
      end
      it 'タグで絞り込み検索ができること' do
        article_with_tag
        article_with_another_tag
        visit admin_articles_path
        within 'select[name="q[tag_id]"]' do
          select 'Ruby'
        end
        click_button '検索'
        expect(page).to have_content(article_with_tag.title), 'タグで検索ができていません'
        expect(page).not_to have_content(article_with_another_tag.title), 'タグで絞り込み検索できていません'
      end
      it '公開状態の記事について、本文で絞り込み検索ができること' do
        visit edit_admin_article_path(past_article_with_sentence.uuid)
        click_on '公開する'
        visit edit_admin_article_path(past_article_with_another_sentence.uuid)
        click_on '公開する'
        visit admin_articles_path
        fill_in 'q[body]', with: '基礎編アプリ'
        click_button '検索'
        expect(page).to have_content(past_article_with_sentence.title), '公開状態の記事について、本文での検索できていません'
        expect(page).not_to have_content(past_article_with_another_sentence.title), '公開状態の記事について、本文での絞り込み検索ができていません'
      end
      it '公開待ちの記事について、本文で絞り込み検索ができること' do
        visit edit_admin_article_path(future_article_with_sentence.uuid)
        click_on '公開する'
        visit edit_admin_article_path(future_article_with_another_sentence.uuid)
        click_on '公開する'
        visit admin_articles_path
        fill_in 'q[body]', with: '基礎編アプリ'
        click_button '検索'
        expect(page).to have_content(future_article_with_sentence.title), '公開状態の記事について、本文での検索できていません'
        expect(page).not_to have_content(future_article_with_another_sentence.title), '公開状態の記事について、本文での絞り込み検索ができていません'
      end
      it '下書きの記事について、本文で絞り込み検索ができること' do
        visit edit_admin_article_path(draft_article_with_sentence.uuid)
        click_on '公開する'
        visit edit_admin_article_path(draft_article_with_another_sentence.uuid)
        click_on '公開する'
        visit admin_articles_path
        fill_in 'q[body]', with: '基礎編アプリ'
        click_button '検索'
        expect(page).to have_content(draft_article_with_sentence.title), '公開状態の記事について、本文での検索できていません'
        expect(page).not_to have_content(draft_article_with_another_sentence.title), '公開状態の記事について、本文での絞り込み検索ができていません'
      end
    end
  end    
end
