require 'digest/sha1'
require 'parser'
require 'tempfile'

module Extensions
  class << self
    attr_accessor :iseq_dir, :modifiers

    def add(modifier)
      modifiers << modifier
    end

    def clear
      Dir.glob(File.join(iseq_dir, '**/*.yarb')) { |path| File.delete(path) }
    end

    def configure
      yield self
    end

    def iseq_path_for(source_path)
      source_path.gsub(/[^A-Za-z0-9\._-]/) { |c| '%02x' % c.ord }.gsub('.rb', '.yarb')
    end
  end

  self.iseq_dir =
    File.expand_path(File.join('..', '.iseq'), __dir__)
  FileUtils.mkdir_p(iseq_dir) unless File.directory?(iseq_dir)

  self.modifiers = []
end

require 'extensions/ast_modifier'
require 'extensions/ast_parser'
require 'extensions/regex_modifier'
require 'extensions/source_file'

Dir[File.expand_path('extensions/modifiers/*', __dir__)].each do |modifier_source_file|
  require modifier_source_file
end

Extensions.configure do |config|
  config.add Extensions::Modifiers::DateSigil.new
  config.add Extensions::Modifiers::URISigil.new
  config.add Extensions::Modifiers::NumberSigil.new
  config.add Extensions::Modifiers::TypeSafeMethodArgs.new
  config.add Extensions::Modifiers::TypeSafeMethodReturns.new
end

RubyVM::InstructionSequence.singleton_class.prepend(Module.new do
  def load_iseq(filepath)
    return nil if filepath == File.expand_path('extensions/parser.rb', __dir__)
    ::Extensions::SourceFile.load_iseq(filepath)
  end
end)
