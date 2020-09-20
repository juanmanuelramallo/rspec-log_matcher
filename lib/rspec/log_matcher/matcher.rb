# frozen_string_literal: true

module RSpec
  module LogMatcher
    class Matcher
      LOG_PATH = ENV.fetch('LOG_PATH', 'log/test.log')

      attr_reader :expected_logs, :initial_log_file_position

      def initialize(expected_logs, initial_log_file_position)
        @expected_logs = expected_logs
        @initial_log_file_position = initial_log_file_position || 0
      end

      def matches?(subject)
        prepare_matcher(subject)

        case expected_logs
        when Regexp
          logs.match?(expected_logs)
        when Proc
          logs.include?(expected_logs.call)
        when String
          logs.include?(expected_logs)
        end
      end

      def failure_message
        "Expected subject to have logged `#{expected_logs}' in:\n\t#{logs}"
      end

      def failure_message_when_negated
        "Expected subject not to have logged `#{expected_logs}' in:\n\t#{logs}"
      end

      def supports_block_expectations?
        true
      end

      private

      def log_file
        @log_file ||= File.new(LOG_PATH)
      end

      def logs
        @logs ||= log_file.read
      end

      def prepare_matcher(subject)
        if subject.is_a?(Proc)
          log_file.seek(0, IO::SEEK_END)
          subject.call
        elsif defined?(Capybara::Session) && subject.is_a?(Capybara::Session)
          log_file.seek(initial_log_file_position)
        end
      end
    end
  end
end
