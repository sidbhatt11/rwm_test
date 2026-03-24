# frozen_string_literal: true

class NotificationJob
  attr_reader :dispatcher

  def initialize
    @dispatcher = Notifications::Dispatcher.new
  end

  def welcome(user_id)
    dispatcher.deliver_to_user(
      user_id,
      subject: "Welcome to the platform!",
      body: "Thanks for signing up. We're glad to have you.",
      channel: :email
    )
  end

  def payment_received(user_id, amount_display)
    dispatcher.deliver_to_user(
      user_id,
      subject: "Payment received",
      body: "We received your payment of #{amount_display}. Thanks!",
      channel: :email
    )
  end

  def alert(user_id, message)
    dispatcher.deliver_to_user(
      user_id,
      subject: "Alert",
      body: message,
      channel: :in_app
    )
  end
end
