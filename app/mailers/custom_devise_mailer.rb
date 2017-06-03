class CustomDeviseMailer < Devise::Mailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.mailgun_mailer.email_confirmation.subject
  #
 helper :application # gives access to all helpers defined within `application_helper`.
 include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
 default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views
 default from: "chahal.vikas43@gmail.com"

  def confirmation_instructions(record, token, opts={})
    @resource = record
    @token = token
    opts[:resource] = record
    opts[:subject] = "Activate your account"
    headers['X-Mailgun-Variables'] = {:email => @resource.email}.to_json
    in_time = Time.now + 2.days
    CommunicationWorker.perform_in(in_time,@resource.id)
    mail to: "#{@resource.email}"
    super
  end
end
