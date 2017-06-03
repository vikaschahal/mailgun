# MailgunWebhooks.api_key = "key-63203fd6d350653577c47785ff30203b"
# MailgunWebhooks.api_host = "sandbox3c819ebb63b540e3b988831c30a2c0d0.mailgun.org"
# Mailgun.configure do |config|
#   config.api_key = 'key-63203fd6d350653577c47785ff30203b'
#   config.domain  = 'andbox3c819ebb63b540e3b988831c30a2c0d0.mailgun.org'
# end
#
# @mailgun = Mailgun()

# @mailgun = Mailgun(:api_key => 'key-63203fd6d350653577c47785ff30203b')
app_config = File.join(Rails.root,'config','application.yml')
raise "#{appplicatin_config} is missing!" unless File.exists? app_config
config = YAML.load_file(app_config).symbolize_keys

@M_KEY= config[:MAILGUN_KEY]
@M_DOMAIN = config[:MAILGUN_DOMAIN]
