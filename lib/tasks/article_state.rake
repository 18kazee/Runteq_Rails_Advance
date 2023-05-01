namespace :article_state do
  desc '公開待ちの中で、公開日時が過去になっているものがあれば、ステータスを公開にする。'
  task change_to_be_publishd: :environment do
    Article.publish_wait.past_publishd.find_each(&:publishd!)
  end
end
