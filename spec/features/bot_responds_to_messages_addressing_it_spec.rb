require 'spec_helper'
require 'support/fake_slack_client'

describe "Bot response" do
  let(:ri_double) {spy("RiLookup")}
  let(:username) { 'fakeuser' }
  let(:id) {'U22S4ET41'}
  let(:fake_slack) { FakeSlackClient.new(name: username, id: id) }
  let(:slack_api_token) { "DUMMY-12345-dummy-67890-DMY" }
  let(:doc_bot) {DocumentationBot.new(slack_api_token, {slack_client: fake_slack, ri_lookup: ri_double})}

  before(:each) do
    doc_bot.start!
  end

  context "triggers" do
    it "when the bot's userid is used" do
      message = {"channel"=>"CDUMMYDUMMY1", "user"=>"FAKEFAKE1", "text"=>"hello <@#{id}>"}
    end

    it "when the bot's username is used" do
      message = {"channel"=>"CDUMMYDUMMY1", "user"=>"FAKEFAKE1", "text"=>"#{username} test"}

      expect(fake_slack).to receive(:message)
      fake_slack.execute(:message, message)
    end

    it "when the bot is private messaged" do 
      message = {"channel"=>"DDUMMYDUMMY1", "user"=>"FAKEFAKE1", "text"=>"Here is an unrelated message"}

      expect(fake_slack).to receive(:message)
      fake_slack.execute(:message, message)
    end
  end

  context "does not trigger" do 
    it "when there is a channel message but the bot is not mentioned" do 
      message = {"channel"=>"CDUMMYDUMMY1", "user"=>"FAKEFAKE1", "text"=>"Here is an unrelated message"}

      expect(fake_slack).not_to receive(:message)
      fake_slack.execute(:message, message)
    end
  end
end