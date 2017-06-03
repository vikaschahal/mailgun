class CommunicationWorker
  include Sidekiq::Worker

  def perform(*args)
    return if args.blank?
    user = User.find(args[0])
    return if user.blank?
    MailgunMailer.activation_reminder(user.email,user.name) if user.confirmed_at.blank? && !MailgunTask.email_on_suppression?(user.email)
  end
end
