namespace :article_summary do
  desc 'am9:00に公開済み記事の集計結果を管理者にメールする'
  task maill_article_summary: :environment do
    Article_Mailer.report_summary.deliver_now
  end
end
