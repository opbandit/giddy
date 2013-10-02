require 'bundler/gem_tasks'
require 'rdoc/task'

desc "Create documentation"
Rake::RDocTask.new("doc") { |rdoc|
  rdoc.title = "Giddy - Getty Connect API library for Ruby"
  rdoc.rdoc_dir = 'docs'
  rdoc.rdoc_files.include('README.md')
  rdoc.rdoc_files.include('lib/**/*.rb')
}
