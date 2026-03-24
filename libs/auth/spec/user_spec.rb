# frozen_string_literal: true

require "spec_helper"
require "auth"

RSpec.describe Auth::User do
  before { described_class.reset! }

  describe ".register" do
    it "creates a user with an auto-incremented id" do
      user = described_class.register(email: "alice@example.com", name: "Alice", password: "secret")

      expect(user.id).to eq("1")
      expect(user.email).to eq("alice@example.com")
      expect(user.name).to eq("Alice")
    end
  end

  describe ".find_by_email" do
    it "returns a registered user" do
      described_class.register(email: "bob@example.com", name: "Bob", password: "pw")
      user = described_class.find_by_email("bob@example.com")

      expect(user.name).to eq("Bob")
    end

    it "returns nil for unknown emails" do
      expect(described_class.find_by_email("nobody@example.com")).to be_nil
    end
  end

  describe "#valid_password?" do
    it "accepts the correct password" do
      user = described_class.register(email: "a@b.com", name: "A", password: "correct")
      expect(user.valid_password?("correct")).to be true
    end

    it "rejects a wrong password" do
      user = described_class.register(email: "a@b.com", name: "A", password: "correct")
      expect(user.valid_password?("wrong")).to be false
    end
  end
end
