class MailgunWebhookController < ApplicationController

  def webhooks
    MailgunTask.create_csv_file(params)
    msg = {:status => "ok" }
    render :json => msg
  end


end
