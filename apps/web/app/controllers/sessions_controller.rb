# frozen_string_literal: true

class SessionsController < ApplicationController
  def create
    token = Auth.authenticate(params[:email], params[:password])

    if token
      render json: { token: token }
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end
  end
end
