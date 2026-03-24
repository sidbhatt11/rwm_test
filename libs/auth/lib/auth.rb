# frozen_string_literal: true

require_relative "auth/token"
require_relative "auth/user"

module Auth
  VERSION = "0.1.0"

  def self.authenticate(email, password)
    user = User.find_by_email(email)
    return nil unless user&.valid_password?(password)

    Token.generate(user_id: user.id, email: user.email)
  end
end
