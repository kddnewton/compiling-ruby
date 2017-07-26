require 'digest/sha1'
require 'extensions/regex_modifier'
require 'extensions/source_file'

module Extensions
  class << self
    attr_accessor :iseq_dir, :modifiers

    def clear
      Dir.glob(File.join(iseq_dir, '**/*.yarb')) { |path| File.delete(path) }
    end

    def iseq_path_for(source_path)
      source_path.gsub(/[^A-Za-z0-9\._-]/) { |c| '%02x' % c.ord }.gsub('.rb', '.yarb')
    end
  end

  self.iseq_dir =
    File.expand_path(File.join('..', '.iseq'), __dir__)
  FileUtils.mkdir_p(iseq_dir) unless File.directory?(iseq_dir)

  self.modifiers = [
    RegexModifier.new(/~d\((.+?)\)/, 'Date.parse("\1")'),
    RegexModifier.new(/~u\((.+?)\)/, 'URI.parse("\1")')
  ]
end

RubyVM::InstructionSequence.singleton_class.prepend(Module.new do
  def load_iseq(filepath)
    ::Extensions::SourceFile.load_iseq(filepath)
  end
end)
