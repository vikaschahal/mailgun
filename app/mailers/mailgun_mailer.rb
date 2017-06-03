class MailgunMailer < ApplicationMailer
  helper :application # gives access to all helpers defined within `application_helper`.
  default from: "chahal.vikas43@gmail.com"

  def activation_reminder(email_to,name)
    @name = name
    mail(to: "#{email_to}",
         subject: "Waiting to from you").deliver
  end
end
