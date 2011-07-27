source "http://rubygems.org"

gem "rails", "3.1.0.rc4"

gem "mysql2"

# Asset template engines
gem "compass", git: "https://github.com/chriseppstein/compass.git", branch: "rails31"
gem "sass-rails", "~> 3.1.0.rc"
gem "uglifier"

gem "jquery-rails"

# Use unicorn as the web server
# gem "unicorn"

# Deploy with Capistrano
# gem "capistrano"

gem "cancan"
gem "carrierwave"
# gem "dally"
gem "haml-rails"
gem "hoptoad_notifier"
gem "i18n-js"
# gem "kaminari"
gem "omniauth"
# gem "oa-oauth", :require => "omniauth/oauth"
# gem "oa-openid", :require => "omniauth/openid"
gem "permalink"
gem "rmagick"
gem "simple_form"
gem "sprockets", "= 2.0.0.beta.10"
gem "swiss_knife"

group :development do
  gem "foreman"
  gem "rails-footnotes"

  # To use debugger
  gem "awesome_print"
  gem "ruby-debug19"
end

group :test do
  gem "capybara"
  gem "factory_girl_rails", ">= 1.0.0"
  gem "ffaker"
  gem "fuubar"
  gem "guard-spork"
  gem "shoulda-matchers"
  gem "simplecov"
  gem "spork", ">= 0.9.0.rc9"
end

group :development, :test do
  gem "factory_girl_generator"
  gem "guard-rspec"
  gem "jasmine"
  gem "rspec-rails"
end
