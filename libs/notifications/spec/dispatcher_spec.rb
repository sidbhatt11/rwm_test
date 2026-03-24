# frozen_string_literal: true

require "spec_helper"
require "notifications"

RSpec.describe Notifications::Dispatcher do
  before { Auth::User.reset! }

  let(:user) { Auth::User.register(email: "alice@example.com", name: "Alice", password: "pw") }

  describe "#deliver" do
    it "records a sent message" do
      dispatcher = described_class.new
      msg = Notifications::Message.new(to: "bob@example.com", subject: "Hi", body: "Hello")

      expect(dispatcher.deliver(msg)).to be true
      expect(dispatcher.sent.size).to eq(1)
    end
  end

  describe "#deliver_to_user" do
    it "looks up the user and dispatches" do
      dispatcher = described_class.new
      dispatcher.deliver_to_user(user.id, subject: "Welcome", body: "You're in!")

      expect(dispatcher.summary).to eq("1 notification(s) dispatched")
      expect(dispatcher.sent.first[:message].to).to eq("alice@example.com")
    end

    it "raises for unknown users" do
      dispatcher = described_class.new
      expect {
        dispatcher.deliver_to_user("ghost", subject: "Yo", body: "Hey")
      }.to raise_error(ArgumentError, /Unknown user/)
    end
  end
end
