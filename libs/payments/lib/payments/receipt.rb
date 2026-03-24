# frozen_string_literal: true

module Payments
  class Receipt
    attr_reader :charge, :issued_at

    def initialize(charge)
      raise ArgumentError, "Charge not completed" unless charge.status == :completed

      @charge = charge
      @issued_at = Time.now
    end

    def to_s
      user = Auth::User.find_by_id(charge.user_id)
      name = user&.name || "Unknown"

      <<~TEXT
        === RECEIPT ===
        ID:     #{charge.id}
        To:     #{name}
        Amount: #{charge.amount_display}
        Date:   #{issued_at.strftime("%Y-%m-%d %H:%M")}
        ===============
      TEXT
    end
  end
end
