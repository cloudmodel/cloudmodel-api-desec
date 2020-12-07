source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Declare your gem's dependencies in cloud_model-api-desec.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use a debugger
# gem 'byebug', group: [:development, :test]

group :development, :test do
  gem "rspec-rails"
  gem "mongoid-rspec"
  gem "fuubar"
  gem "timecop"
  gem "pry"
  gem 'miniskirt'
  gem 'faker'
  gem 'yard'
  gem 'deep-cover', require: false
  if false
    gem 'cloudmodel', git: 'git@github.com:cloudmodel/cloudmodel.git'
  else
    gem 'cloudmodel', path: '../cloudmodel'
  end

  if true
    gem 'yard-mongoid', git: 'https://github.com/cloudmodel/yard-mongoid.git'
  else
    gem 'yard-mongoid', path: '../yard-mongoid'
  end
end