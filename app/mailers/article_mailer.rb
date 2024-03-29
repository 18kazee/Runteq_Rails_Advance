class ArticleMailer < ApplicationMailer
  def report_summary
    @published_count = Article.published.count
    @article_published_yesterday = Article.published_at_yesterday

    mail(to: 'admin@example.com', subject: '公開済記事の集計結果')
  end
end
