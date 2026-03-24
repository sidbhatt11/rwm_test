# frozen_string_literal: true

require "digest"

module Auth
  class User
    attr_reader :id, :email, :name

    def initialize(id:, email:, name:, password_hash:)
      @id = id
      @email = email
      @name = name
      @password_hash = password_hash
    end

    def valid_password?(password)
      @password_hash == self.class.hash_password(password)
    end

    # In-memory store for demo purposes
    @users = {}

    class << self
      def register(email:, name:, password:)
        id = (@users.size + 1).to_s
        user = new(id: id, email: email, name: name, password_hash: hash_password(password))
        @users[email] = user
        user
      end

      def find_by_email(email)
        @users[email]
      end

      def find_by_id(id)
        @users.values.find { |u| u.id == id }
      end

      def reset!
        @users = {}
      end

      def count
        @users.size
      end

      def hash_password(password)
        Digest::SHA256.hexdigest("#{password}:salted")
      end
    end
  end
end
