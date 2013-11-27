require "bundler/gem_tasks"
$:.unshift File.dirname(__FILE__) + 'lib'
$:.unshift './lib', './spec'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new
task :default => :spec

desc "Run lib/matriz.rb"
task :bin do
   sh "ruby lib/matriz.rb"
end

desc "Run tests with --format documentation"
task :test do
   sh "rspec -I spec/matrix_spec.rb --format documentation"
end

desc "Run tests with format: html"
task :thtml do
   sh "rspec -I spec/matrix_spec.rb --format html"
end

task :rspec do
sh "spec"
end

require 'rdoc/task'

  Rake::RDocTask.new(:rdoc_dev) do |rd|
    rd.main = "README.md"
    rd.rdoc_files.include("README.rdoc", "lib/**/*.rb")
    rd.options << "--all"
  end
