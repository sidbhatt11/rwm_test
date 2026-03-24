# frozen_string_literal: true

class ChargesController < ApplicationController
  def create
    user = Auth::User.find_by_email(params[:email])
    return render json: { error: "User not found" }, status: :not_found unless user

    charge = Payments::Charge.new(user_id: user.id, amount_cents: params[:amount_cents].to_i)

    if charge.process!
      receipt = Payments::Receipt.new(charge)
      render json: { charge_id: charge.id, receipt: receipt.to_s }, status: :created
    else
      render json: { error: "Charge failed" }, status: :unprocessable_entity
    end
  end
end
