# frozen_string_literal: true

module Notifications
  class Dispatcher
    attr_reader :sent

    def initialize
      @sent = []
    end

    def deliver(message)
      @sent << { message: message, delivered_at: Time.now }
      true
    end

    def deliver_to_user(user_id, subject:, body:, channel: :email)
      user = Auth::User.find_by_id(user_id)
      raise ArgumentError, "Unknown user: #{user_id}" unless user

      message = Message.new(to: user.email, subject: subject, body: body, channel: channel)
      deliver(message)
    end

    def summary
      "#{@sent.size} notification(s) dispatched"
    end
  end
end
