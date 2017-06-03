module MailgunTask
  require 'rest-client'
  require 'mailgun'
  require 'csv'
  require 'localtunnel'

  MAILGUN_KEY = "key-63203fd6d350653577c47785ff30203b"
  MAILGUN_DOMAIN = "sandbox3c819ebb63b540e3b988831c30a2c0d0.mailgun.org"
  COMMON_URI = "api:#{MAILGUN_KEY}@api.mailgun.net/v3/#{MAILGUN_DOMAIN}"

  class << self

    #check whether email is on suppressions list
    def email_on_suppression?(email)
      email_on_suppression = false
      get_supp_client
      res = suppressions_response("bounces")
      email_on_suppression = email_matched_on_suppression_list(email,res)
      unless email_on_suppression
        res = suppressions_response("unsubscribes")
        email_on_suppression = email_matched_on_suppression_list(email,res)
      end
      unless email_on_suppression
        res = suppressions_response("complaints")
        email_on_suppression = email_matched_on_suppression_list(email,res)
      end
     return email_on_suppression
    end

    #generate csv file from webhook callback
    def create_csv_file(res)
      CSV.generate(headers: true) do |csv|
         csv << ["Email", "IP", "Message Subject","Webhook type"]
         csv << [res["recipient"],res["ip"],res["my_var_1"],res["event"]]
      end
    end

    #add this url in your mailgun Webhook callback
    def webhook_callback_url
      Localtunnel::Client.start(port: 3000)
      Localtunnel::Client.url + "/email/mailgun"
    end

    private

    def suppressions_response(type)
      res = case type
            when "bounces"
              @supp_client.list_bounces
            when "unsubscribes"
              @supp_client.list_unsubscribes
            when "complaints"
              @supp_client.list_complaints
            end
      res = JSON.parse(res.body)
    end

    def get_mg_client
      @mg_client ||= Mailgun::Client.new("#{MAILGUN_KEY}")
    end

    def get_supp_client
      get_mg_client
      @supp_client ||= @mg_client.suppressions("#{MAILGUN_DOMAIN}")
    end

    def email_matched_on_suppression_list(email,res)
      email_on_suppression = false
      return email_on_suppression if res["items"].blank?
      res["items"].each do |details|
        if details["address"] == email
          email_on_suppression = true
          break
        end
      end
      return email_on_suppression
    end

  end
end
