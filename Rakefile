require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "brigade"
    gem.summary = %Q{Manage a brigade of Chef clients over AMQP}
    gem.description = %Q{Brigade allows you to trigger chef runs over AMQP}
    gem.email = "adam@opscode.com"
    gem.homepage = "http://github.com/adamhjk/brigade"
    gem.authors = ["Adam Jacob"]
    gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.add_development_dependency "yard", ">= 0"

    gem.add_dependency "mixlib-cli", ">= 1.1.0"
    gem.add_dependency "mixlib-log", ">= 1.1.0"
    gem.add_dependency "mixlib-config", ">= 1.1.0"
    gem.add_dependency "chef", ">= 0.8.2"

    gem.executables = [ "brigade", "brigade-client" ]

    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end
