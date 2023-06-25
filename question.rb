class Question
  attr_accessor :question_body, :question_correct_answer, :question_answers

  def initialize(raw_text, raw_answers, raw_correct_answer)
    @question_body = raw_text
    @question_answers = shuffle_answers(raw_answers)
    @question_correct_answer = find_char_by_answer(question_answers, raw_correct_answer)
  end

  # forming an array of strings in the form "#{char}.#{answer}"
  def display_answers
    @question_answers.each_with_index.map { |answer, index| "#{(index + 65).chr}. #{answer}" }
  end

  # reloading the to_s method for the given class, returning a string with the question text
  def to_s
    @question_body
  end

  # method that forms a hash with the keys :question_body, question_correct_answer:, :question_answers (and their values)
  def to_h
    {
      question_body: @question_body,
      question_correct_answer: @question_correct_answer,
      question_answers: @question_answers
    }
  end

  # method that generates information about the object in JSON format
  def to_json
    to_h.to_json
  end

  # method that generates information about the object in yaml format
  def to_yaml
    to_h.to_yaml
  end

  # a method that shuffles the answers
  def shuffle_answers(raw_answers)
    raw_answers.shuffle
  end
 
  # method that finds char by the answer
  def find_char_by_answer(answers, correct_answer)
    index = answers.index(correct_answer)
    char = (index + 65).chr
    char
  end
end