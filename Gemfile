source "https://rubygems.org"

ruby file: '.tool-versions'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.1.2"
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Use Dart SASS [https://github.com/rails/dartsass-rails]
gem "dartsass-rails"

gem "csv"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Audits gems for known security defects (use config/bundler-audit.yml to ignore issues)
  gem "bundler-audit", require: false
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
end
gem "library_design", github: "ukparliament/design-assets", glob: "library_design/*.gemspec", tag: "0.6.12"
gem "irb"
gem "dotenv-rails"
gem "lograge"

group :development do
  gem "annotaterb"
end

group :development, :test do
  gem "byebug", platform: :mri
  gem "pry-rails"
end

group :test do
  gem "capybara"
  gem "rspec-rails"
  gem "selenium-webdriver"
end
