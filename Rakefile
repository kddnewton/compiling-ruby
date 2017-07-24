require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

task default: :test

rule '.rb' => '.y' do |t|
   sh "racc -o #{t.name} #{t.source}"
end

desc 'Build the parser'
task racc: ['lib/yars/parser.rb']
