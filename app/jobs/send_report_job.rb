class SendReportJob < ApplicationJob
  queue_as :report

  def perform(start_date, end_date, email)
    generated_report = ReportService.create_report(start_date, end_date)
    ReportMailer.send_email(generated_report, email).deliver_now
  end
end
