
require 'time'
require 'simplecov'
SimpleCov.start

require 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'
# Add simplecov

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

# Require_relative your lib files here!
require_relative '../lib/administrator'
# require_relative '../lib/passenger'
# require_relative '../lib/trip'
# require_relative '../lib/trip_dispatcher'
