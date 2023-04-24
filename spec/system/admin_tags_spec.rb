require 'rails_helper'

RSpec.describe "adminTags", type: :system do
  let(:admin) { create :user, :admin }
  let(:tag) { create :tag }

  it 'タグのパンくずリストが機能すること' do
    login(admin)
    visit edit_admin_tag_path(tag)
    within('.breadcrumb') do
      click_link 'タグ'
    end
    expect(current_path).to eq(admin_tags_path), 'パンくずのタグを押した時にダッシュボードに遷移していません'
  end
end
