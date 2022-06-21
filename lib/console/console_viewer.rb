require 'codebreaker/game'
require_relative 'show_stats'

module Console
  class ConsoleViewer
    attr_reader :game, :stats_arr
    RULES = 'Rules.txt'

    def initialize
      @stats_arr = []
      @game = Codebreaker::Game.new
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
      file = File.open(RULES)
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
      lets_play
    end

    def result(step)
      result = @game.play(step)
      unexpected_command_message if result.nil?
      you_win(result) if result == '++++'
      you_loose(result) if result =~ /^[1-6]{4}$/
      puts result
    end

    def you_win(result)
      puts "++++ (win)\n\n\t\t Congratulation!!!\nresult is #{result} one mote time?\n"
      menu
    end

    def you_loose(result)
      puts "you loose\n\tone mote time?\n result is #{result}"
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

      not_valid_name unless @game.name_input(name)
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
      ShowStats.show_stats(@game)
      menu
    end
  end
end
