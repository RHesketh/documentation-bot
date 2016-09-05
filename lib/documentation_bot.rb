require 'slack-ruby-client'

class DocumentationBot
	def initialize(slack_api_token, options = {})
		raise ArgumentError.new("A Slack API token must be specified as the first parameter") if slack_api_token.to_s.empty?

		# Configures the ENV token globally
		Slack.configure do |config|
		  config.token = slack_api_token
		end
	end	

	def start!(options = {})
		@output = options[:output]			|| STDOUT
		@client = options[:slack_client] 	|| Slack::RealTime::Client.new
		@client.auth_test if options[:test_authentication]

		@client.on :hello do
		  @output.puts "==> Successfully connected as '#{@client.self.name}' to the '#{@client.team.name}' team at https://#{@client.team.domain}.slack.com."
		  my_channels = channels_i_am_a_member_of
		  @output.puts "==> I'm currently a member of these channels: #{channel_names_with_hash(my_channels)}" if my_channels.count > 0
		end

		@client.on :channel_joined do |e|
			@output.puts "==> I've joined channel ##{e['channel']['name']}"
		end

		@client.on :channel_left do |e|
			@output.puts "==> I've left channel ##{@client.channels[e.channel]['name']}"
		end

		@client.start!
	end

	private 

	def channels_i_am_a_member_of
		@client.channels.map{|a| a[1]}.select{|c| c["is_member"]}.map{|c| c["is_member"]}
	end

	def channel_names_with_hash(channel_names)
		channel_names.map{|c| "##{c}"}.join(', ')
	end
end