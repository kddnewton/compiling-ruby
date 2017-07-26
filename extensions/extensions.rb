require 'digest/sha1'

module Extensions
  class SourceFile
    attr_reader :source_path, :iseq_path

    def initialize(source_path, iseq_path)
      @source_path = source_path
      @iseq_path   = iseq_path
    end

    def dump
      iseq = RubyVM::InstructionSequence.compile_file(source_path)
      digest = ::Digest::SHA1.file(source_path).digest
      File.binwrite(iseq_path, iseq.to_binary("SHA-1:#{digest}"))
      iseq
    rescue SyntaxError, RuntimeError
      nil
    end

    def load
      if File.exist?(iseq_path) && (File.mtime(source_path) <= File.mtime(iseq_path))
        RubyVM::InstructionSequence.load_from_binary(File.binread(iseq_path))
      else
        dump
      end
    end

    def self.load_iseq(source_path)
      new(
        source_path,
        File.join(Extensions.iseq_dir, Extensions.iseq_path_for(source_path))
      ).load
    end
  end

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
