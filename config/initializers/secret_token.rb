# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
#
require 'securerandom'

def secure_token
  token_file = Rails.root.join('.secret')
  if File.exist?(token_file)
    File.read(token_file).chomp
  else
    token = SecureRandom.hex(64)
    File.write(token_file, token)
    token
  end
end

SampleApp::Application.config.secret_token = secure_token
#SampleApp::Application.config.secret_token = '6864343245269bfc85da897b8c081ca5c641073c2686238243aefabf46ffb8a28102abeeae1fe1715d6d6cc5edb808cedc91e738fef84ee86d0449e6103d46dd'
