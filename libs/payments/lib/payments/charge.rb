# frozen_string_literal: true

module Payments
  class Charge
    attr_reader :id, :user_id, :amount_cents, :currency, :status, :created_at

    def initialize(user_id:, amount_cents:, currency: "AUD")
      @id = SecureRandom.hex(8)
      @user_id = user_id
      @amount_cents = amount_cents
      @currency = currency
      @status = :pending
      @created_at = Time.now
    end

    def process!
      user = Auth::User.find_by_id(@user_id)
      raise ArgumentError, "Unknown user: #{@user_id}" unless user

      if @amount_cents <= 0
        @status = :failed
        return false
      end

      # Simulate processing
      @status = :completed
      true
    end

    def amount_display
      dollars = @amount_cents / 100.0
      format("$%.2f %s", dollars, @currency)
    end
  end
end
