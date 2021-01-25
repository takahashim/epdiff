# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/test_*.rb']
end

desc 'Check with rubocop'
task :rubocop do
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new
rescue LoadError
  warn 'rubocop not found'
end

task default: %i[test rubocop]
