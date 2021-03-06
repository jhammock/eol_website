source 'https://rubygems.org'

# The REALLY basic stuff stays at the top:

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.10'
# Use mysql2 as the database for Active Record
gem 'mysql2'

# Asset-related gems next:

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
# Use jquery as the JavaScript library TODO ... I don't think we do, anymore?
gem 'jquery-rails'
# Use SCSS for stylesheets
gem 'sass-rails'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', group: :doc
# javascript code from rails TODO: I don't think we want this, but could be wrong.
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# RefineryCMS
gem 'refinerycms'
gem 'refinerycms-wymeditor' #, ['~> 2.0', '>= 2.0.0']
gem 'refinerycms-i18n'

# Use Unicorn as the app server
gem 'unicorn'

# Pagination with kaminari. It's out of order because the methods it uses need
# to be defined first for other classes to recognize them:
gem 'kaminari'

# All other non-environment-specific gems come next.
#
# ALPHABETICALLY, PLEASE.
#
# ...and with a comment above each gem (or block of related gems) explaining what it's for. Let's keep this
# maintainable!

# For bulk inserts:
gem 'activerecord-import'
# Acts As List simplifies ordered lists of models:
gem 'acts_as_list'
# Faster startup:
gem 'bootsnap', require: false
# Counter Culture handled cached counts of things (which we use ALL OVER):
gem 'counter_culture'
# Run background jobs:
gem 'daemons'
# Memcached (not for development):
gem 'dalli'
# Background jobs (to be run by daemons, q.v.):
gem 'delayed_job', '~> 4.1.4'
gem 'delayed_job_active_record'
# Devise handles authentication and some authorization:
gem 'devise', '~> 4.4.1'
gem 'devise-i18n-views'
gem 'devise-encryptable'
# Discourse handles comments and chat:
gem 'discourse_api'

# This is used to locally have a copy of OpenSans. IF YOU STOP USING OPENSANS, YOU SHOULD REMOVE THIS GEM!
gem 'font-kit-rails'
# Because ERB is just plain silly compared to Haml:
gem 'haml-rails'
# QUIET PLEASE MAKE IT STOP:
gem 'lograge'
# Neography is used for our Triple Store for now:
gem 'neography'
# Site monitoring for staging and production:
gem 'newrelic_rpm'
# OpenAuth logins from our preferred sources:
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'omniauth-google-oauth2'
gem 'omniauth-yahoo'
# Debugging:
gem 'pry-rails'
# Authorization:
gem 'pundit'
# Turing test:
gem 'recaptcha', require: 'recaptcha/rails'
# ElasticSearch via SearchKick:
gem 'searchkick'
# Simplify Forms:
gem 'simple_form'
gem 'client_side_validations'
gem 'client_side_validations-simple_form'
# Icons
gem 'font-awesome-sass'
# Model decoration
gem 'draper', '~> 2.1.0'
# Zip file support
gem 'rubyzip', '>= 1.0.0'

# VULNERABILITY FIXES (these can be removed when their parent gems are updated):
gem 'loofah', '2.2.1' # Used by spec, addresses https://github.com/flavorjones/loofah/issues/144

group :development, :test do
  # Security analysis:
  gem 'brakeman', :require => false
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  # Coveralls tracks our spec coverage:
  gem 'coveralls', require: false
  # Simplecov, oddly, to add configuration for Coveralls.
  gem 'simplecov'
  # Rubocop... which technically you want on your *system*, but ...
  gem 'rubocop'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  #for simulating confirmation mails
  gem 'mailcatcher'

  # For benchmarking queries:
  gem 'meta_request'
end

group :test do
  gem 'rspec-rails', '~> 3.7.2'
  # TEMP - remove rack-protection, required by rspec, eventually. Here
  # temporarily to circumvent https://nvd.nist.gov/vuln/detail/CVE-2018-1000119
  gem 'rack-protection', '~> 1.5.5'
  # NOTE: I added this when I got a "expected [HTML] to respond to `has_tag?`",
  # but it didn't help, so I'm removing it. Hmmn.
  # gem "rspec-html-matchers"
  gem 'better_errors'
  gem 'capybara'
  gem 'factory_girl'
  gem 'faker'
  gem 'rack_session_access'
  gem 'shoulda-matchers', '~> 3.1'
end
