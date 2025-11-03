# frozen_string_literal: true

require_relative 'word_controller'

# Class that stores methods and variables of hangman game
class Game
  def initialize
    @secret_word = WordController.new
    @visible_word = '_' * secret_word.word_size
    @attempts = 0
    @difficulty = ask_difficulty

    unless secret_word.same?(visible_word) || attempts >= DIFFICULTIES[difficulty][:attempts]
      self.attempts += 1
      play
    end

    game_over
  end

  private

  attr_reader :new_word, :visible_word, :secret_word

  attr_accessor :attempts, :difficulty

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

  def ask_difficulty
    puts "Choose the difficulty (1-#{DIFFICULTIES.size}):"
    difficulty_number = 0

    DIFFICULTIES.each_key do |key|
      difficulty_number += 1
      puts "- #{difficulty_number}: #{key}"
    end

    print '>>> '

    difficulty = gets.to_i - 1

    if (0...DIFFICULTIES.size).include?(difficulty)
      DIFFICULTIES.keys[difficulty]
    else
      puts "Wrong input! Difficulty number outside of allowed range (1 to #{DIFFICULTIES.size})"
      ask_difficulty
    end
  end

  def game_retry
    self.class.new
  end

  def game_leave
    puts 'See you next time!'
  end

  def game_over
    print "Game over! Do you want to retry? [Y/n]\n>>> "
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

  def play; end
end
