require 'rails_helper'

RSpec.describe 'AdminSites', type: :system do
  let(:admin) { create(:user, :admin) }
  let(:article) { create(:article) }

  before do
    login(admin)
    visit edit_admin_site_path
  end

  describe 'ブログのトップ画像を変更する' do
    context '画像を1枚選択してアップロード' do
      it 'トップ画像が変更される' do
        attach_file 'site_main_images', "spec/fixtures/images/sample.png"
        click_on '保存'
        expect(page).to have_selector("img[src$='sample.png']"), 'トップ画像がアップロードされていません'
      end
    end

    context '画像を複数選択してアップロード' do
      it 'トップ画像が変更される' do
        attach_file 'site_main_images', ["spec/fixtures/images/sample.png", "spec/fixtures/images/sample2.png"]
        click_on '保存'
        expect(page).to have_selector("img[src$='sample.png']"), '複数のトップ画像がアップロードされていません'
        expect(page).to have_selector("img[src$='sample2.png']"), '複数のトップ画像がアップロードされていません'
      end
    end

    context 'アップロード済みのトップ画像を削除する' do
      it 'トップ画像が削除される' do
        attach_file 'site_main_images', "spec/fixtures/images/sample.png"
        click_on '保存'
        expect(page).to have_selector("img[src$='sample.png']"), 'トップ画像がアップロードされていません'
        click_on '削除'
        expect(page).not_to have_selector("img[src$='sample.png']"), 'トップ画像が削除されていません'
      end
    end
  end
  describe 'favicon画像を変更する' do
    context '画像を1枚選択してアップロード' do
      it 'favicon画像が変更される' do
        attach_file 'site_favicon', "spec/fixtures/images/sample.png"
        click_on '保存'
        expect(page).to have_selector("img[src$='sample.png']"), 'favicon画像がアップロードされていません'
      end
    end

    context 'アップロード済みのfavicon画像を削除する' do
      it 'favicon画像が削除される' do
        attach_file 'site_favicon', "spec/fixtures/images/sample.png"
        click_on '保存'
        expect(page).to have_selector("img[src$='sample.png']"), 'favicon画像がアップロードされていません'
        click_on '削除'
        expect(page).not_to have_selector("img[src$='sample.png']"), 'favicon画像が削除されていません'
      end
    end
  end

  describe 'og-image画像を変更する' do
    context '画像を1枚選択してアップロード' do
      it 'og-image画像が変更される' do
        attach_file 'site_og_image', "spec/fixtures/images/sample.png"
        click_on '保存'
        expect(page).to have_selector("img[src$='sample.png']"), 'og-image画像がアップロードされていません'
      end
    end

    context 'アップロード済みのog-image画像を削除する' do
      it 'og-image画像が削除される' do
        attach_file 'site_og_image', "spec/fixtures/images/sample.png"
        click_on '保存'
        expect(page).to have_selector("img[src$='sample.png']"), 'og-image画像がアップロードされていません'
        click_on '削除'
        expect(page).not_to have_selector("img[src$='sample.png']"), 'og-image画像が削除されていません'
      end
    end
  end
end






