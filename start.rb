require './environment'

slack_api_token = ENV['SLACK_API_TOKEN']

puts "==> Starting DocumentationBot using API token '#{slack_api_token}'"
doc_bot = DocumentationBot.new(slack_api_token)
doc_bot.start!