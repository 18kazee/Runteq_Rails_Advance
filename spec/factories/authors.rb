# == Schema Information
#
# Table name: taxonomies
#
#  id          :bigint           not null, primary key
#  type        :string(255)
#  name        :string(255)
#  slug        :string(255)
#  description :text(65535)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_taxonomies_on_slug  (slug)
#  index_taxonomies_on_type  (type)
#

FactoryBot.define do
  factory :author do
    sequence(:name) { |n| "著者#{n}" }
    sequence(:slug) { |n| "author#{n}" }
  end
end
