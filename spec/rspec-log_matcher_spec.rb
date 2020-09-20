# frozen_string_literal: true

RSpec.describe RSpec::LogMatcher::Matcher do
  log_path = 'spec/fixtures/application.log.copy'

  around(:each) do |example|
    FileUtils.cp('spec/fixtures/application.log', log_path)
    example.run
    File.delete(log_path)
  end

  before do
    stub_const 'RSpec::LogMatcher::Matcher::LOG_PATH', log_path
  end

  write_to_logs = proc { |text| File.open(log_path, 'a') { |f| f << text } }

  describe '#matches?' do
    # When the subject is an HTTP call from a request spec
    # or any other block of code.
    # Example:
    #
    #   expect { subject }.to log(something)
    #
    context 'when the subject is a proc' do
      # Example:
      #
      #   expect { subject }.to log('something')
      #
      context 'when the expected logs is a string' do
        it 'returns true' do
          expected_logs = 'this should be logged'

          expect { write_to_logs.call(expected_logs) }.to log(expected_logs)
        end

        it 'returns false' do
          unexpected_logs = 'this will not be logged'

          expect { write_to_logs.call('something else') }.not_to log(unexpected_logs)
        end
      end

      # Example:
      #
      #   expect { subject }.to log(/something/)
      #
      context 'when the expected logs is a regular expression' do
        it 'returns true' do
          expect { write_to_logs.call('payment_id=98765') }.to log(/payment_id=[0-9]+/)
        end

        it 'returns false' do
          expect { write_to_logs.call('payment_id=98765') }.not_to log(/payment_id=[a-z]+/)
        end
      end

      # Example:
      #
      #   expect { subject }.to log { something }
      #
      context 'when the expected logs is a proc' do
        it 'returns true' do
          expect { write_to_logs.call('from a proc') }.to log(proc { 'from a proc' })
        end

        it 'returns false' do
          expect { write_to_logs.call('something else') }.not_to log(proc { 'will not be logged' })
        end
      end
    end

    # When the subject is a Capybara::Session from a system/feature spec
    # Example:
    #
    # RSpec.feature 'Some feature' do
    #   scenario 'some test' do
    #     visit some_path
    #
    #     expect(page).to log('something')
    #     expect(page).to log(/something/)
    #     expect(page).to log { something }
    #   end
    # end
    #
    context 'when the subject is a Capybara::Session' do
      before do
        stub_const 'Capybara::Session', Class.new
      end

      it 'returns true' do
        write_to_logs.call(
          "application logs\n"\
          "and more application logs\n"\
          "this should be logged\n"\
          'more stuff is logged'
        )
        page = Capybara::Session.new

        expect(page).to log('this should be logged')
      end

      it 'returns false' do
        write_to_logs.call(
          "application logs\n"\
          "and more application logs\n"\
          "this should be logged\n"\
          'more stuff is logged'
        )
        page = Capybara::Session.new

        expect(page).not_to log('this should not be logged')
      end
    end
  end
end
