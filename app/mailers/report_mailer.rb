class ReportMailer < ApplicationMailer
  def send_email(report, email)
    @report = report
    mail(to: email, from: 'ksltsn@yandex.ru')
  end
end
