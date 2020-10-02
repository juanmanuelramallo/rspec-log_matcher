# RSpec::LogMatcher

[![Gem Version](https://badge.fury.io/rb/rspec-log_matcher.svg)](https://badge.fury.io/rb/rspec-log_matcher)
[![ci](https://github.com/juanmanuelramallo/rspec-log_matcher/workflows/ci/badge.svg?branch=master)](https://github.com/juanmanuelramallo/rspec-log_matcher/actions)
[![Maintainability](https://api.codeclimate.com/v1/badges/145ad4334a67d5e1f8a2/maintainability)](https://codeclimate.com/github/juanmanuelramallo/rspec-log_matcher/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/145ad4334a67d5e1f8a2/test_coverage)](https://codeclimate.com/github/juanmanuelramallo/rspec-log_matcher/test_coverage)

## What is this?
An RSpec custom matcher to test code that logs information into log files.

Writing logs is an easy way to store any kind of information for further analysis later on. It's commonly used to store analytics events and then make the logs a data source for data engineering tasks. This matcher makes application-logging-testing easier.

## Installation

Add this line to your application's Gemfile:

```ruby
group :test do
  gem 'rspec-log_matcher'
end
```

And then execute:

    $ bundle install

## Usage

### Plain old ruby objects

```ruby
# app/services/payment_service.rb
class PaymentService
  def self.call
    # [snip]

    logger.info "event=payment-successful properties=#{data.to_json}"
  end
end
```

```ruby
# spec/services/payment_service_spec.rb
require 'spec_helper'

RSpec.describe PaymentService do
  describe '.call' do
    subject { described_class.call }

    it 'logs event information' do
      expect { subject }.to log("event=payment-successful properties=#{build_expected_json}")
    end
  end
end
```

### Request specs
```ruby
# spec/requests/users_spec.rb
require 'spec_helper'

RSpec.describe 'Users' do
    describe 'GET /index' do
        expect { get(users_path) }.to log('Page view - Users index')
    end
end
```

### Feature specs

```ruby
# spec/features/sign_in_spec.rb
require 'spec_helper'

RSpec.feature 'Sign in' do
  scenario 'successful sign in' do
    user = create(:user)

    visit sign_in_path
    fill_form(user)
    submit_form

    expect(page).to have_text('Welcome!')
    expect(page).to log("User #{user.id} has logged in")
  end
end
```

Regular expressions and procs are also valid object types for the expected logs, for more use cases refer to the [spec file](https://github.com/juanmanuelramallo/rspec-log_matcher/blob/master/spec/rspec-log_matcher_spec.rb).

## Configuration

The default path for the log file is `log/test.log`. It can be configured via an environment variable called `LOG_PATH`.

This is useful when tests are run parallely, and each process has their own log file.

## How it works?

The matcher reads into the log file and looks for the expected logs to be present in the log file.

When the subject is a proc, the matcher will execute proc and compare against the logs introduced by the proc execution.

When the subject is a Capybara::Session (from a feature spec, system tests), the matcher will store the position in the file to the last byte in a before hook. Then, when the example is run, it will compare against the changes introduced by the example using the position stored as the beginning of the logs.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/juanmanuelramallo/rspec-log_matcher. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/juanmanuelramallo/rspec-log_matcher/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Rspec::LogMatcher project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/juanmanuelramallo/rspec-log_matcher/blob/master/CODE_OF_CONDUCT.md).
