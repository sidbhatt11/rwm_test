# frozen_string_literal: true

require "spec_helper"
require "payments"

RSpec.describe Payments::Charge do
  before { Auth::User.reset! }

  let(:user) { Auth::User.register(email: "buyer@example.com", name: "Buyer", password: "pw") }

  describe "#process!" do
    it "completes a valid charge" do
      charge = described_class.new(user_id: user.id, amount_cents: 2500)
      expect(charge.process!).to be true
      expect(charge.status).to eq(:completed)
    end

    it "fails for zero amount" do
      charge = described_class.new(user_id: user.id, amount_cents: 0)
      expect(charge.process!).to be false
      expect(charge.status).to eq(:failed)
    end

    it "raises for unknown user" do
      charge = described_class.new(user_id: "ghost", amount_cents: 100)
      expect { charge.process! }.to raise_error(ArgumentError, /Unknown user/)
    end
  end

  describe "#amount_display" do
    it "formats cents as dollars with currency" do
      charge = described_class.new(user_id: user.id, amount_cents: 4999)
      expect(charge.amount_display).to eq("$49.99 AUD")
    end
  end
end
