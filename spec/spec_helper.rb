# frozen_string_literal: true

require 'stringio'
require 'simplecov'
require 'codebreaker/game'
SimpleCov.start
SimpleCov.minimum_coverage 90

require 'lib/console/console_viewer'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
