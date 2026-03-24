# frozen_string_literal: true

require "spec_helper"
require "auth"

RSpec.describe Auth::Token do
  describe ".generate" do
    it "returns a three-part JWT-like string" do
      token = described_class.generate(user_id: "1", email: "test@example.com")
      expect(token.split(".").size).to eq(3)
    end
  end

  describe ".verify" do
    it "round-trips a valid token" do
      token = described_class.generate(user_id: "42", email: "alice@example.com")
      payload = described_class.verify(token)

      expect(payload[:user_id]).to eq("42")
      expect(payload[:email]).to eq("alice@example.com")
      expect(payload[:iat]).to be_a(Integer)
      expect(payload[:jti]).to be_a(String)
    end

    it "rejects a tampered token" do
      token = described_class.generate(user_id: "1", email: "test@example.com")
      tampered = token.reverse

      expect(described_class.verify(tampered)).to be_nil
    end

    it "rejects garbage input" do
      expect(described_class.verify("not.a.token")).to be_nil
      expect(described_class.verify("")).to be_nil
    end
  end
end
