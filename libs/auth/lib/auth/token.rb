# frozen_string_literal: true

require "openssl"
require "json"
require "base64"
require "securerandom"

module Auth
  module Token
    SECRET = ENV.fetch("AUTH_SECRET", "dev-secret-do-not-use-in-prod")

    def self.generate(payload)
      header = Base64.urlsafe_encode64({ alg: "HS256", typ: "JWT" }.to_json)
      body = Base64.urlsafe_encode64(payload.merge(iat: Time.now.to_i, jti: SecureRandom.hex(8)).to_json)
      signature = sign("#{header}.#{body}")

      "#{header}.#{body}.#{signature}"
    end

    def self.verify(token)
      parts = token.split(".")
      return nil unless parts.size == 3

      header, body, signature = parts
      return nil unless signature == sign("#{header}.#{body}")

      JSON.parse(Base64.urlsafe_decode64(body), symbolize_names: true)
    rescue ArgumentError, JSON::ParserError
      nil
    end

    def self.sign(data)
      Base64.urlsafe_encode64(
        OpenSSL::HMAC.digest("SHA256", SECRET, data)
      )
    end
    private_class_method :sign
  end
end
