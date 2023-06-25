require 'yaml'
require 'json'
require_relative 'question'

class QuestionData
  attr_reader :collection

  # initializing attributes and calling the load_data method
  def initialize(yaml_dir, in_ext)
    @collection = []
    @yaml_dir = prepare_filename(yaml_dir)
    @in_ext = in_ext
    @threads = []
    load_data
  end

  # initializing attributes and calling the load_data method to form a collection of questions in yaml format
  def to_yaml
    @collection.map(&:to_h).to_yaml
  end

  # saving a collection of questions in yaml format to a file
  def save_to_yaml(filename)
    File.write(prepare_filename(filename), to_yaml)
  end

  # forming a collection of questions in json format
  def to_json
    @collection.map(&:to_h).to_json
  end

  # saving a collection of questions in json format to a file
  def save_to_json(filename)
    File.write(prepare_filename(filename), to_json)
  end

  # forming an absolute path
  def prepare_filename(filename)
    File.expand_path(filename, __dir__)
  end

  # method that takes a block as input and executes it on each file in a given directory
  def each_file(&block)
    Dir.glob(File.join(@yaml_dir, "*#{@in_ext}"), &block)
  end

  # running a block of code in a separate thread and adding the thread to the thread array
  def in_thread(&block)
    @threads << Thread.new(&block)
  end

  # uploading information about tests and forming a collection of questions with the help of methods
  def load_data
    each_file do |filename|
      puts filename
      in_thread do
        load_from(filename)
      end
    end

    @threads.each(&:join)
  end

  # reading information from a yml file, shuffling answers, forming Question-type objects and adding them to the collection
  def load_from(filename)
    data = YAML.load_file(filename)
    data.each do |raw_question|
      question_body = raw_question['question']
      question_answers = raw_question['answers']
      correct_answer = raw_question['correct_answer']
      question = Question.new(question_body, question_answers, correct_answer)
      @collection << question
    end
  end
end