# frozen_string_literal: true

namespace :demo do
  desc "Seed demo users and process a sample charge"
  task seed: :environment do
    puts "==> Seeding demo data..."

    Auth::User.reset!

    alice = Auth::User.register(email: "alice@example.com", name: "Alice Melbourne", password: "password123")
    bob = Auth::User.register(email: "bob@example.com", name: "Bob Rubyist", password: "hunter2")

    puts "  Created #{Auth::User.count} users: #{alice.name}, #{bob.name}"

    charge = Payments::Charge.new(user_id: alice.id, amount_cents: 4200, currency: "AUD")
    charge.process!
    receipt = Payments::Receipt.new(charge)

    puts receipt.to_s
    puts "==> Seed complete!"
  end
end
