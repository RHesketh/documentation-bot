require 'spec_helper'
require File.join($ROOT, 'lib', 'documentation_bot')

describe DocumentationBot do
  let(:SLACK_API_KEY) { "DUMMY-12345-dummy-67890-DMY" }

  describe "#new" do
    it "errors if the Slack API key is passed in as first argument" do
      expect{DocumentationBot.new}.to raise_error(ArgumentError)
    end

    it "does not error if the Slack API key is passed in as first argument" do
      expect{
      doc_bot = DocumentationBot.new(SLACK_API_KEY)
      }.not_to raise_error(ArgumentError)
    end
  end
end