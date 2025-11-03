# frozen_string_literal: true

require 'colorize'

require_relative 'word_controller'
require_relative 'ascii_art'

# Class that stores methods and variables of hangman game
class Game
  def initialize
    pp_welcome

    @secret_word = WordController.new
    @visible_word = '_' * secret_word.word_size
    @attempts = 0
    @difficulty = ask_difficulty

    play unless secret_word.same?(visible_word) || attempts >= DIFFICULTIES[difficulty][:attempts]

    game_over
  end

  private

  attr_reader :new_word, :secret_word

  attr_accessor :attempts, :difficulty, :visible_word

  DIFFICULTIES = {
    easy: {
      attempts: 16
    },
    normal: {
      attempts: 12
    },
    hard: {
      attempts: 8
    },
    impossible: {
      attempts: 4
    }
  }.freeze

  def pp_welcome
    puts AsciiArt::HANGMAN_BY_ITS_NAMAMI
  end

  def ask_difficulty_number
    puts "Choose the difficulty (1-#{DIFFICULTIES.size}):"
    difficulty_number = 0

    DIFFICULTIES.each_key do |key|
      difficulty_number += 1
      puts "- #{difficulty_number}: #{key}"
    end

    print '>>> '

    gets.to_i - 1
  end

  def ask_difficulty
    difficulty = ask_difficulty_number

    if (0...DIFFICULTIES.size).include?(difficulty)
      DIFFICULTIES.keys[difficulty]
    else
      puts "Wrong input! Difficulty number outside of allowed range (1 to #{DIFFICULTIES.size})\n"
      ask_difficulty
    end
  end

  def game_retry
    self.class.new
  end

  def game_leave
    puts AsciiArt::SEE_YOU_NEXT_TIME
  end

  def ask_retry
    print "Do you want to retry? [Y/n]\n>>> "
    answer = gets.chomp
    puts

    case answer.downcase
    when 'y', '' then game_retry
    when 'n' then game_leave
    else
      puts 'Invalid input!'
      game_over
    end
  end

  def game_over
    if secret_word.same?(visible_word)
      puts AsciiArt::WIN
    else
      puts AsciiArt::LOSE
    end

    ask_retry
  end

  def left_attempts
    DIFFICULTIES[difficulty][:attempts] - attempts
  end

  def pp_game_state
    colorized_word = visible_word.each_char.map { |char| char.eql?('_') ? char.red : char.blue }.join('')
    puts "Word: #{colorized_word}"
    puts '♥'.red * left_attempts
  end

  def reveal_letter(letter, letter_indexes)
    letter_indexes.each do |index|
      visible_word[index] = letter
    end
  end

  def ask_letter
    print "Input the letter you want to try\n>>> "
    letter = gets.chomp
    puts

    return ask_letter if letter.length != 1

    letter_indexes = secret_word.letter_indexes(letter)

    reveal_letter(letter, letter_indexes) unless letter_indexes.empty?
  end

  def play
    pp_game_state
    ask_letter

    play unless secret_word.same?(visible_word) || left_attempts.zero?

    pp_game_state
  end
end
