# frozen_string_literal: true

require_relative 'lib/rspec/log_matcher/version'

Gem::Specification.new do |spec|
  spec.name          = 'rspec-log_matcher'
  spec.version       = Rspec::LogMatcher::VERSION
  spec.authors       = ['Juan Manuel Ramallo']
  spec.email         = ['juanmanuelramallo@hey.com']

  spec.summary       = 'RSpec custom matcher to test code that logs information into log files.'
  spec.description   = 'Logs are an easy way to store any kind of information for further '\
                       'analysis later on. It\'s commonly used to store analytics events '\
                       'and then make the logs a source for data engineering tasks. This '\
                       'matcher makes logging testing easier.'
  spec.homepage      = 'https://github.com/juanmanuelramallo/rspec-log_matcher'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/juanmanuelramallo/rspec-log_matcher'
  spec.metadata['changelog_uri'] = 'https://github.com/juanmanuelramallo/rspec-log_matcher/blob/master/CHANGELOG.md'

  spec.files = Dir['LICENSE.txt', 'README.md', 'CHANGELOG.md', 'lib/**/*']
  spec.require_paths = ['lib']

  spec.add_dependency 'rspec-core', ['>= 3', '< 4']
  spec.add_development_dependency 'rspec', '~> 3.9.0'
  spec.add_development_dependency 'rubocop', '~> 0.91'
  spec.add_development_dependency 'simplecov', '~> 0.17.1'
end
