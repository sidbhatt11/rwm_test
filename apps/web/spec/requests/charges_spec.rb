# frozen_string_literal: true

require "spec_helper"

RSpec.describe "POST /charges", type: :request do
  before do
    Auth::User.register(email: "buyer@example.com", name: "Buyer", password: "pw")
  end

  it "processes a charge and returns a receipt" do
    post "/charges", params: { email: "buyer@example.com", amount_cents: 2500 }

    expect(response).to have_http_status(:created)
    body = JSON.parse(response.body)
    expect(body["receipt"]).to include("$25.00 AUD")
    expect(body["receipt"]).to include("Buyer")
  end

  it "returns not_found for unknown user" do
    post "/charges", params: { email: "nobody@example.com", amount_cents: 100 }

    expect(response).to have_http_status(:not_found)
  end
end
