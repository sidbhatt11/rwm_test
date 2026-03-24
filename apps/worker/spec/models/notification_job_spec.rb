# frozen_string_literal: true

require "spec_helper"

RSpec.describe NotificationJob do
  let(:user) { Auth::User.register(email: "alice@example.com", name: "Alice", password: "pw") }

  describe "#welcome" do
    it "sends a welcome email" do
      job = described_class.new
      job.welcome(user.id)

      expect(job.dispatcher.sent.size).to eq(1)
      msg = job.dispatcher.sent.first[:message]
      expect(msg.subject).to eq("Welcome to the platform!")
      expect(msg.to).to eq("alice@example.com")
      expect(msg.channel).to eq(:email)
    end
  end

  describe "#payment_received" do
    it "sends a payment confirmation" do
      job = described_class.new
      job.payment_received(user.id, "$25.00 AUD")

      msg = job.dispatcher.sent.first[:message]
      expect(msg.body).to include("$25.00 AUD")
    end
  end

  describe "#alert" do
    it "sends an in-app alert" do
      job = described_class.new
      job.alert(user.id, "Something happened")

      msg = job.dispatcher.sent.first[:message]
      expect(msg.channel).to eq(:in_app)
      expect(msg.body).to eq("Something happened")
    end
  end
end
