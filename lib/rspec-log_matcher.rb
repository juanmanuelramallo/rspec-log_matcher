# frozen_string_literal: true

require 'rspec/log_matcher'

module RSpec
  module LogMatcher
    class Error < StandardError; end

    def log(expected_logs)
      Matcher.new(expected_logs, @log_file_position)
    end

    ::RSpec.configure do |config|
      config.before(:each, type: :feature) do
        @log_file_position = File.new(Matcher::LOG_PATH).sysseek(0, IO::SEEK_END)
      end

      config.include ::RSpec::LogMatcher
    end
  end
end
