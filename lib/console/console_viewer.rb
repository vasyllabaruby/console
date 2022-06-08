require 'codebreaker/game'
require_relative 'show_stats'

class ConsoleViewer
  include(ShowStats)
  include(Codebreaker)
  attr_reader :game, :stats_arr

  def initialize
    @stats_arr = []
    @game = Game.new
  end

  def welcome
    puts 'Welcome!!!'
    menu
  end

  def menu
    puts "Please input command: \n\tstart\n\trules\n\tstats\n\texit"
    command = gets.chomp
    case command
    when 'start' then game_registration
    when 'rules' then rules
    when 'stats' then stats
    when 'exit' then exit
    else puts 'You have passed unexpected command. Please choose one from listed commands', menu
    end
  end

  def rules
    file = File.open('Rules.txt')
    puts file.read
    file.close
    menu
  end

  def game_registration
    @game.new_game(input_name, choose_difficulty)
    puts "\n\t\tGame started   !!!!"
    lets_play
  end

  private

  def lets_play
    step = gets.chomp.to_s
    hint if step == 'hint'
    exit if step == 'exit'
    result(step)
    if @game.attempts.positive?
      lets_play
    else
      you_loose
    end
  end

  def result(step)
    result = @game.play(step)
    unexpected_command_message if result.nil?
    you_win if result == '++++ (win)'
    puts result
  end

  def you_win
    puts "++++ (win)\n\n\t\t Congratulation!!!\none mote time?\n"
    menu
  end

  def you_loose
    puts "you loose\n\tone mote time?\n"
    menu
  end

  def hint
    puts @game.hint
    lets_play
  end

  def exit
    abort 'Goodbye'
  end

  def unexpected_command_message
    puts 'Invalid values Please input: hint, exit or code'
    lets_play
  end

  def input_name
    puts 'Please input your name'
    name = gets.chomp
    return if name.equal?('exit')

    not_valid_name unless Codebreaker.name_valid?(name)
    name
  end

  def not_valid_name
    puts 'your name not valid, must be mor then 3 characters and less then 20'
    input_name
  end

  def choose_difficulty
    puts "Please choose difficulty:\n\tEasy\n\tMedium\n\tHell"
    diff = gets.chomp.downcase.to_sym
    diff_values = %i[easy medium hell]
    return diff if diff_values.include?(diff)

    choose_difficulty
  end

  def stats
    ::ShowStats.show_stats(@game)
    menu
  end
end
