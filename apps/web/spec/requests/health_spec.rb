# frozen_string_literal: true

require "spec_helper"

RSpec.describe "GET /health", type: :request do
  it "returns ok with auth version" do
    get "/health"

    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body["status"]).to eq("ok")
    expect(body["version"]).to eq(Auth::VERSION)
  end
end
