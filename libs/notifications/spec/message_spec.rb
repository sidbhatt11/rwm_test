# frozen_string_literal: true

require "spec_helper"
require "notifications"

RSpec.describe Notifications::Message do
  it "creates an email message by default" do
    msg = described_class.new(to: "alice@example.com", subject: "Hello", body: "Hi there")

    expect(msg.channel).to eq(:email)
    expect(msg.to_s).to include("[email]")
    expect(msg.to_s).to include("Hello")
  end

  it "supports sms and in_app channels" do
    sms = described_class.new(to: "+61400000000", subject: "Alert", body: "Check this", channel: :sms)
    expect(sms.channel).to eq(:sms)

    in_app = described_class.new(to: "user@test.com", subject: "New", body: "Update", channel: :in_app)
    expect(in_app.channel).to eq(:in_app)
  end

  it "rejects unknown channels" do
    expect {
      described_class.new(to: "a@b.com", subject: "X", body: "Y", channel: :pigeon)
    }.to raise_error(ArgumentError, /Unknown channel/)
  end
end
