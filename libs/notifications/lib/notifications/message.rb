# frozen_string_literal: true

module Notifications
  class Message
    attr_reader :to, :subject, :body, :channel

    CHANNELS = %i[email sms in_app].freeze

    def initialize(to:, subject:, body:, channel: :email)
      raise ArgumentError, "Unknown channel: #{channel}" unless CHANNELS.include?(channel)

      @to = to
      @subject = subject
      @body = body
      @channel = channel
    end

    def to_s
      "[#{channel}] To: #{to} | #{subject}"
    end
  end
end
