require 'rubygems'
require 'bundler'
Bundler.setup

require 'rake'
require 'foodcritic'
require 'rubocop/rake_task'

task :default => [:foodcritic, :rubocop]

FoodCritic::Rake::LintTask.new do |t|
  t.options = {:fail_tags => ['correctness']}
end

Rubocop::RakeTask.new
