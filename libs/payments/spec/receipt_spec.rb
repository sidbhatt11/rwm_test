# frozen_string_literal: true

require "spec_helper"
require "payments"

RSpec.describe Payments::Receipt do
  before { Auth::User.reset! }

  let(:user) { Auth::User.register(email: "buyer@example.com", name: "Buyer", password: "pw") }

  it "generates a receipt for a completed charge" do
    charge = Payments::Charge.new(user_id: user.id, amount_cents: 1500)
    charge.process!

    receipt = described_class.new(charge)
    text = receipt.to_s

    expect(text).to include("Buyer")
    expect(text).to include("$15.00 AUD")
    expect(text).to include("RECEIPT")
  end

  it "rejects an incomplete charge" do
    charge = Payments::Charge.new(user_id: user.id, amount_cents: 1000)
    expect { described_class.new(charge) }.to raise_error(ArgumentError, /not completed/)
  end
end
