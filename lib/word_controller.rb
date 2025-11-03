# frozen_string_literal: true

# Class that chooses and compares example word
class WordController
  def initialize
    @word = WORDS.sample
  end

  def word_size
    word.size
  end

  def letter_indexes(letter)
    word.each_char.with_index.filter_map do |char, index|
      index if letter.downcase.eql?(char.downcase)
    end
  end

  def same?(guess_word)
    word.eql?(guess_word)
  end

  private

  attr_reader :word

  WORDS = File.readlines(File.join(__dir__, '../data/google-10000-english-no-swears.txt')).map(&:chomp).freeze
end
