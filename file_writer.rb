class FileWriter
  def initialize(mode, *args)
    @answers_dir = args[0]
    @filename = args[1]
    @mode = mode
  end

  def write(message)
    File.open(prepare_filename, @mode) do |file|
      file.puts message
    end
  end

  def prepare_filename
    File.expand_path(File.join(@answers_dir, @filename), __dir__)
  end
end
