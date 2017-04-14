require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

file :copy_content do
  mkdir_p 'test/integration/serverspec'
  cp_r 'lib/serverspec/.', 'test/integration/default/serverspec'
end

task 'update_cookbook' => [:copy_content]

task :default => :spec
