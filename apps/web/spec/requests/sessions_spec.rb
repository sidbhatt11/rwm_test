# frozen_string_literal: true

require "spec_helper"

RSpec.describe "POST /sessions", type: :request do
  before do
    Auth::User.register(email: "alice@example.com", name: "Alice", password: "secret")
  end

  it "returns a token for valid credentials" do
    post "/sessions", params: { email: "alice@example.com", password: "secret" }

    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body["token"]).to be_a(String)

    payload = Auth::Token.verify(body["token"])
    expect(payload[:email]).to eq("alice@example.com")
  end

  it "rejects invalid credentials" do
    post "/sessions", params: { email: "alice@example.com", password: "wrong" }

    expect(response).to have_http_status(:unauthorized)
  end
end
