# frozen_string_literal: true

namespace :demo do
  desc "Seed demo users and dispatch sample notifications"
  task seed: :environment do
    puts "==> Seeding demo data..."

    Auth::User.reset!

    alice = Auth::User.register(email: "alice@example.com", name: "Alice Melbourne", password: "password123")
    bob = Auth::User.register(email: "bob@example.com", name: "Bob Rubyist", password: "hunter2")

    puts "  Created #{Auth::User.count} users"

    job = NotificationJob.new

    job.welcome(alice.id)
    job.welcome(bob.id)
    job.alert(alice.id, "Your account is ready")

    puts "  #{job.dispatcher.summary}"
    puts "==> Seed complete!"
  end
end
