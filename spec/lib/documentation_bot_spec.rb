require 'spec_helper'

describe DocumentationBot do
  let(:slack_api_token) { "DUMMY-12345-dummy-67890-DMY" }

  describe "#new" do
    it "errors if the Slack API key is passed in as first argument" do
      expect{DocumentationBot.new}.to raise_error(ArgumentError)
    end

    it "does not error if the Slack API key is passed in as first argument" do
      expect{
        doc_bot = DocumentationBot.new(slack_api_token)
      }.not_to raise_error
    end
  end

  describe '#start!' do
    describe ':test_authentication option' do
      it "Should perform an auth test when true" do 
        slack_client_double = spy("Slack::RealTime::Client")
        doc_bot = DocumentationBot.new(slack_api_token)

        expect(slack_client_double).to receive(:auth_test)
        doc_bot.start!(test_authentication: true, slack_client: slack_client_double)
      end

      it "Should not perform an auth test when false" do
        slack_client_double = spy("Slack::RealTime::Client")
        doc_bot = DocumentationBot.new(slack_api_token)

        expect(slack_client_double).not_to receive(:auth_test)
        doc_bot.start!(test_authentication: false, slack_client: slack_client_double)
      end

      it "Should not perform an auth test when not present" do 
        slack_client_double = spy("Slack::RealTime::Client")
        doc_bot = DocumentationBot.new(slack_api_token)

        expect(slack_client_double).not_to receive(:auth_test)
        doc_bot.start!(slack_client: slack_client_double)
      end
    end
  end
end