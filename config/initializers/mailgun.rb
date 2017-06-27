app_config = File.join(Rails.root,'config','application.yml')
raise "#{appplicatin_config} is missing!" unless File.exists? app_config
config = YAML.load_file(app_config).symbolize_keys

@M_KEY= config[:MAILGUN_KEY]
@M_DOMAIN = config[:MAILGUN_DOMAIN]
