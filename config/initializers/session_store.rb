# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_cloud_app2_session',
  :secret      => '030e7420bb5dc6370031ec28f043630fb86d41b6f786417aa58e08802e722d95b0c51556e27daa2bfe05fdb82e79e3f73dbaed0ffefdc3bbb64bc3305c17455b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
