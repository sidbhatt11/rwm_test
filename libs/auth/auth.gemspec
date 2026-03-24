# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "auth"
  spec.version = "0.1.0"
  spec.authors = ["TODO: Your name"]
  spec.summary = "TODO: Summary of auth"

  spec.files = Dir.glob("lib/**/*")
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 3.2.0"

  spec.add_dependency "base64"
end
