require 'slack-ruby-client'

# Public: Watch Slack channels and Direct Messages for requests to look up
# Ruby documentation. Will stay running once #start! is called.
#
# Examples
#   slack_token = 'abc123'
#   docbot = DocumentationBot.new(slack_token)
#   docbot.start!
class DocumentationBot
  # Public: Create a new DocumentationBot
  #
  # slack_api_token - a String containing the Slack API token the bot should
  #                   use to connect. A valid token from Slack is needed.
  # options - A Hash containing optional replacements for internal services 
  #           used by the bot (default: {})
  #           :output       - An IO object that receives all of the debug
  #                           output. Defaults to STDOUT (optional).
  #           :slack_client - The Slack RealTime API Client that will be
  #                           communicating with Slack's API (optional).
  #           :ri_lookup    - The lookup service that communicates with the
  #                           `ri` command-line tool (optional).
  #           :parser       - A parser that takes Markdown and converts it to
  #                           the format used by Slack (optional).
  #
  # Examples
  #   DocumentationBot.new('abc123')
  #
  #   my_output = StringIO.new
  #   DocumentationBot.new('abc123', output: my_output)
  def initialize(slack_api_token, options = {})
    raise ArgumentError.new("A Slack API token must be specified as the first parameter") if slack_api_token.to_s.empty?
    Slack.configure do |config|
      config.token = slack_api_token
    end

    @output = options[:output]      || STDOUT
    @client = options[:slack_client]  || Slack::RealTime::Client.new
    @ri_lookup = options[:ri_lookup]  || RiLookup.new
    @slack_parser = options[:parser]  || MarkdownToSlack.new
  end 

  # Public: Start the bot running and connect to Slack.
  #
  # options - a Hash containing options that change the bot's behaviour
  #           :test_authentication - Call to Slack's test authentication
  #                                  API to check credentials (optional).
  # Examples
  #
  #   docbot = DocumentationBot.new('abc123')
  #   docbot.start!
  #
  # Does not return, will execute indefinitely once called.
  def start!(options = {})
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

    @client.on :message do |message_data|
      next if message_data["text"].to_s.empty?
      next if message_originates_from_the_bot? message_data
      next unless message_is_addressed_to_the_bot? message_data

      command = get_command_from_incoming_message message_data["text"]

      case command.downcase
      when "help"
        clean_output = help_information
      else
        clean_output = handle_ri_lookup(command)
      end

      @client.message channel: message_data["channel"], text: clean_output
    end

    @client.start!
  end

  private 
  def handle_ri_lookup(command)
    raw_output = @ri_lookup.find(command)
    clean_output = @slack_parser.convert raw_output
    clean_output = "Sorry, couldn't find any information about '#{command}'." if clean_output.empty?

    return clean_output
  end

  def help_information
    "*Usage:*   `#{@client.self.name} [Ruby class/method]`\n" +
    "     e.g. `#{@client.self.name} Array`"
  end

  def get_command_from_incoming_message(message)
    output = message.gsub(/^\<\@#{@client.self.id}\> /, "") # Strip our userid if it's in there
    output = output.gsub(/^#{@client.self.name} /, "")    # Strip our username if it's in there

    return output
  end

  def message_originates_from_the_bot?(message_data)
    return message_data["user"] == @client.self.id
  end

  def message_is_addressed_to_the_bot?(message_data)
    return true if message_is_direct_message message_data["channel"]
    return true if user_id_was_mentioned? message_data["text"]
    return true if username_was_mentioned? message_data["text"]

    return false
  end

  def user_id_was_mentioned?(message)
    return message.scan(/^\<\@#{@client.self.id}\>/).count > 0
  end

  def username_was_mentioned?(message)
    return message.downcase =~ /^#{@client.self.name.downcase}/
  end

  def message_is_direct_message(channel)
    return channel[0] == "D"
  end

  def channels_i_am_a_member_of
    @client.channels.map{|a| a[1]}.select{|c| c["is_member"]}.map{|c| c["name"]}
  end

  def channel_names_with_hash(channel_names)
    channel_names.map{|c| "##{c}"}.join(', ')
  end
end