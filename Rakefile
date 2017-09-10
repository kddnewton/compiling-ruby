require 'rake/extensiontask'

desc 'Build the tuby parser'
task :tuby do
  sh 'racc -o tuby/lib/tuby/parser.rb tuby/lib/tuby/parser.y'
end

Rake::ExtensionTask.new('tuby') do |ext|
  ext.ext_dir = File.join('tuby', 'ext', 'tuby')
  ext.lib_dir = File.join('tuby', 'lib', 'tuby')
end
