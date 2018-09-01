class ReportsController < ApplicationController
  def by_author
    start_date, end_date = params[:start_date], params[:end_date]
    email = params[:email]

    if start_date && end_date && email
      render json: { message: "Report generation started.", status: 200}
      SendReportJob.perform_later(start_date, end_date, email)
    else
      render json: {errors: 'Not enough parameters for generating report.', status: 400}
    end
  end
end
