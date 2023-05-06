require 'rails_helper'

RSpec.describe 'AdimnPolicies', type: :system do
  let(:admin) { create :user, :admin }
  let(:writer) { create :user, :writer }
  let(:editor) { create :user, :editor } 
  let(:category) { create :category }
  let(:tag) { create :tag }
  let(:author) { create :author }

  before do
    driven_by(:rack_test)
  end

  describe 'ライターのアクセス権限' do
    before do
      login(writer)
      visit admin_articles_path
    end
    context 'ダッシュボードにアクセスしたとき' do
      it 'タグページへのリンクが表示されないこと' do
        expect(page).not_to have_link('タグ'), 'タグが表示されています'
      end
      it '著者ページへのリンクが表示されないこと' do
        expect(page).not_to have_link('著者'), '著者が表示されています'
      end
      it 'カテゴリーページへのリンクが表示されないこと' do
        expect(page).not_to have_link('カテゴリー'), 'カテゴリーが表示されています'
      end
    end
    context 'カテゴリー一覧ページにアクセスしたとき' do
      it 'アクセスが失敗し、403エラーが表示されること' do
        visit admin_categories_path
        expect(page).to have_http_status(403), 'カテゴリー一覧ページにアクセス成功しています'
        expect(page).not_to have_content('category.name'), 'カテゴリー一覧ページが表示されています'
      end
    end
    context 'カテゴリー編集ページにアクセスしたとき' do
      it 'アクセスが失敗し、403エラーが表示されること' do
        visit edit_admin_category_path(category)
        expect(page).to have_http_status(403), 'カテゴリー編集ページにアクセス成功しています'
        expect(page).not_to have_selector("input[value=#{category.name}]"), 'カテゴリー編集ページが表示されています'
      end
    end
    context 'タグ一覧ページにアクセスしたとき' do
      it 'アクセスが失敗し、403エラーが表示されること' do
        visit admin_tags_path
        expect(page).to have_http_status(403), 'タグ一覧ページにアクセス成功しています'
        expect(page).not_to have_content('tag.name'), 'タグ一覧ページが表示されています'
      end
    end
    context 'タグ編集ページにアクセスしたとき' do
      it 'アクセスが失敗し、403エラーが表示されること' do
        visit edit_admin_tag_path(tag)
        expect(page).to have_http_status(403), 'タグ編集ページにアクセス成功しています'
        expect(page).not_to have_selector("input[value=#{tag.name}]"), 'タグ編集ページが表示されています'
      end
    end
    context '著者一覧ページにアクセスしたとき' do
      it 'アクセスが失敗し、403エラーが表示されること' do
        visit admin_authors_path
        expect(page).to have_http_status(403), '著者一覧ページにアクセス成功しています'
        expect(page).not_to have_content('author.name'), '著者一覧ページが表示されています'
      end
    end
    context '著者編集ページにアクセスしたとき' do
      it 'アクセスが失敗し、403エラーが表示されること' do
        visit edit_admin_author_path(author)
        expect(page).to have_http_status(403), '著者編集ページにアクセス成功しています'
        expect(page).not_to have_selector("input[value=#{author.name}]"), '著者編集ページが表示されています'
      end
    end
  end
  describe '編集者のアクセス権限' do
    before do
      login(editor)
      visit admin_articles_path
    end
    context 'ダッシュボードにアクセスしたとき' do
      it 'カテゴリーページへのリンクが表示されること' do
        expect(page).to have_link('カテゴリー'), 'カテゴリーが表示されていません'
      end
      it 'タグページへのリンクが表示されること' do
        expect(page).to have_link('タグ'), 'タグが表示されていません'
      end
      it '著者ページへのリンクが表示されること' do
        expect(page).to have_link('著者'), '著者が表示されていません'
      end
    end
    context 'カテゴリー一覧ページにアクセスしたとき' do
      it 'アクセスが成功し、カテゴリー一覧ページが表示されること' do
        visit admin_categories_path
        expect(page).to  have_http_status(200), 'カテゴリー一覧ページにアクセスできていません'
        expect(page).to have_content('カテゴリー'), 'カテゴリー一覧ページが表示されていません'
      end
    end
    context 'カテゴリー編集ページにアクセスしたとき' do
      it 'アクセスが成功し、カテゴリー編集ページが表示されること' do
        visit edit_admin_category_path(category)
        expect(page).to have_http_status(200), 'カテゴリー編集ページにアクセスできていません'
        expect(page).to have_selector("input[value=#{category.name}]"), 'カテゴリー編集ページが表示されていません'
      end
    end
    context 'タグ一覧ページにアクセスしたとき' do
      it 'アクセスが成功し、タグ一覧ページが表示されること' do
        visit admin_tags_path
        expect(page).to have_http_status(200), 'タグ一覧ページにアクセスできていません'
        expect(page).to have_content('タグ'), 'タグ一覧ページが表示されていません'
      end
    end
    context 'タグ編集ページにアクセスしたとき' do
      it 'アクセスが成功し、タグ編集ページが表示されること' do
        visit edit_admin_tag_path(tag)
        expect(page).to have_http_status(200), 'タグ編集ページにアクセスできていません'
        expect(page).to have_selector("input[value=#{tag.name}]"), 'タグ編集ページが表示されていません'
      end
    end
    context '著者一覧ページにアクセスしたとき' do
      it 'アクセスが成功し、著者一覧ページが表示されること' do
        visit admin_authors_path
        expect(page).to have_http_status(200), '著者一覧ページにアクセスできていません'
        expect(page).to have_content('著者'), '著者一覧ページが表示されていません'
      end
    end
    context '著者編集ページにアクセスしたとき' do
      it 'アクセスが成功し、著者編集ページが表示されること' do
        visit edit_admin_author_path(author)
        expect(page).to have_http_status(200), '著者編集ページにアクセスできていません'
        expect(page).to have_selector("input[value=#{author.name}]"), '著者編集ページが表示されていません'
      end
    end
  end
  describe '管理者のアクセス権限' do
    before do
      login(admin)
      visit admin_articles_path
    end
    context 'ダッシュボードにアクセスしたとき' do
      it 'カテゴリーページへのリンクが表示されること' do
        expect(page).to have_link('カテゴリー'), 'カテゴリーが表示されていません'
      end
      it 'タグページへのリンクが表示されること' do
        expect(page).to have_link('タグ'), 'タグが表示されていません'
      end
      it '著者ページへのリンクが表示されること' do
        expect(page).to have_link('著者'), '著者が表示されていません'
      end
    end
    context 'カテゴリー一覧ページにアクセスしたとき' do
      it 'アクセスが成功し、カテゴリー一覧ページが表示されること' do
        visit admin_categories_path
        expect(page).to  have_http_status(200), 'カテゴリー一覧ページにアクセスできていません'
        expect(page).to have_content('カテゴリー'), 'カテゴリー一覧ページが表示されていません'
      end
    end
    context 'カテゴリー編集ページにアクセスしたとき' do
      it 'アクセスが成功し、カテゴリー編集ページが表示されること' do
        visit edit_admin_category_path(category)
        expect(page).to have_http_status(200), 'カテゴリー編集ページにアクセスできていません'
        expect(page).to have_selector("input[value=#{category.name}]"), 'カテゴリー編集ページが表示されていません'
      end
    end
    context 'タグ一覧ページにアクセスしたとき' do
      it 'アクセスが成功し、タグ一覧ページが表示されること' do
        visit admin_tags_path
        expect(page).to have_http_status(200), 'タグ一覧ページにアクセスできていません'
        expect(page).to have_content('タグ'), 'タグ一覧ページが表示されていません'
      end
    end
    context 'タグ編集ページにアクセスしたとき' do
      it 'アクセスが成功し、タグ編集ページが表示されること' do
        visit edit_admin_tag_path(tag)
        expect(page).to have_http_status(200), 'タグ編集ページにアクセスできていません'
        expect(page).to have_selector("input[value=#{tag.name}]"), 'タグ編集ページが表示されていません'
      end
    end
    context '著者一覧ページにアクセスしたとき' do
      it 'アクセスが成功し、著者一覧ページが表示されること' do
        visit admin_authors_path
        expect(page).to have_http_status(200), '著者一覧ページにアクセスできていません'
        expect(page).to have_content('著者'), '著者一覧ページが表示されていません'
      end
    end
    context '著者編集ページにアクセスしたとき' do
      it 'アクセスが成功し、著者編集ページが表示されること' do
        visit edit_admin_author_path(author)
        expect(page).to have_http_status(200), '著者編集ページにアクセスできていません'
        expect(page).to have_selector("input[value=#{author.name}]"), '著者編集ページが表示されていません'
      end
    end
  end
end
