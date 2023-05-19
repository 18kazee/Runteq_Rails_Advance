require "rails_helper"

RSpec.describe ArticleMailer, type: :mailer do
  let(:article_tomorrow) { create :article, :published_tomorrow }
  let(:article_yesterday) { create :article, :published_yesterday }
  let(:article_two_days_ago) { create :article, :published_two_days_ago }
  let(:mail) { ArticleMailer.report_summary.deliver_now }
  let(:check_sent_mail) {
    expect(mail.present?).to be_truthy, 'メールが送信されていません'
    expect(mail.to).to eq(['admin@example.com']), 'メールの送信先が正しくありません'
    expect(mail.subject).to eq('公開済記事の集計結果'), 'メールのタイトルが正しくありません'
  }

  describe '公開記事の集計結果通知メールの送信' do
    context '公開日が昨日と2日前の記事が存在する時' do
      it '公開日が2日前分の記事の結果が送られること' do
        article_tomorrow
        article_yesterday
        article_two_days_ago
        check_sent_mail
        expect(mail.body).to match('公開済の記事数: 2件')
        expect(mail.body).to match('2')
        expect(mail.body).to match('タイトル: ' + article_yesterday.title), '公開された記事のタイトルが表示されていません'
        expect(mail.body).not_to match('タイトル: ' + article_tomorrow.title), '公開されていない記事のタイトルが表示されています'
        expect(mail.body).not_to match('タイトル: ' + article_two_days_ago.title), '昨日以前に公開された記事のタイトルが表示されています'
      end
    end
    context '昨日までに公開記事が存在しない時' do
      it '記事がない旨の結果が送られること' do
        article_tomorrow
        check_sent_mail
        expect(mail.body).to match('公開済の記事数: 0件'), '昨日公開された記事数が正しくありません'
        expect(mail.body).to match('0'), '公開済の記事数が正しくありません'
        expect(mail.body).to match('昨日公開された記事はありません'), '昨日公開された記事数が正しくありません'
        expect(mail.body).not_to match('タイトル: ' + article_tomorrow.title), '公開されていない記事のタイトルが表示されています'
      end
    end
    context '公開日が昨日の記事が存在する時' do
      it '公開日が昨日の記事を含めて結果が送られること' do
        article_yesterday
        article_tomorrow
        check_sent_mail
        expect(mail.body).to match('公開済の記事数: 1件'), '昨日公開された記事数が正しくありません'
        expect(mail.body).to match('1'), '公開済の記事数が正しくありません'
        expect(mail.body).to match('タイトル: ' + article_yesterday.title), '公開された記事のタイトルが表示されていません'
        expect(mail.body).not_to match('タイトル: ' + article_tomorrow.title), '公開されていない記事のタイトルが表示されています'
      end
    end
    context '公開日が2日前の記事が存在する時' do
      it '公開日が2日前の記事を含めて結果が送られること' do
        article_two_days_ago
        article_tomorrow
        check_sent_mail
        expect(mail.body).to match('公開済の記事数: 1件')
        expect(mail.body).to match('1')
        expect(mail.body).to match('昨日公開された記事はありません'), '昨日公開された記事数が正しくありません'
        expect(mail.body).not_to match('タイトル: ' + article_two_days_ago.title), '公開された記事のタイトルが表示されていません'
        expect(mail.body).not_to match('タイトル: ' + article_tomorrow.title), '公開されていない記事のタイトルが表示されています'
      end
    end
  end
end
