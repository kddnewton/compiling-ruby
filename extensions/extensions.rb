require 'digest/sha1'
require 'extensions/source_file'

module Extensions
  class << self
    attr_accessor :iseq_dir

    def clear
      Dir.glob(File.join(iseq_dir, '**/*.yarb')) { |path| File.delete(path) }
    end

    def iseq_path_for(source_path)
      source_path.gsub(/[^A-Za-z0-9\._-]/) { |c| '%02x' % c.ord }
    end
  end

  self.iseq_dir =
    File.expand_path(File.join('..', '.iseq'), __dir__)

  FileUtils.mkdir_p(iseq_dir) unless File.directory?(iseq_dir)
end

RubyVM::InstructionSequence.singleton_class.prepend(Module.new do
  def load_iseq(filepath)
    ::Extensions::SourceFile.load_iseq(filepath)
  end
end)
