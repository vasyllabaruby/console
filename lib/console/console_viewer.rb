require 'codebreaker/game'
require_relative 'stats'

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
      when 'start' then play
      when 'rules' then rules
      when 'stats' then stats
      when 'exit' then exit
      else puts 'You have passed unexpected command. Please choose one from listed commands', menu
      end
      menu
    end

    def rules
      file = File.open(RULES)
      puts file.read
      file.close
    end

    def play
      @game.new_game(input_name, choose_difficulty)
      puts "\n\t\tGame started   !!!!"
      make_step
    end

    private

    def make_step
      step = gets.chomp.to_s
      case step
      when 'hint' then hint
      when 'exit' then exit
      else
        result(step)
      end
      make_step
    end

    def result(step)
      result = @game.play(step)
      unexpected_command_message if result.nil?
      you_win(result) if result == '++++'
      you_loose(result) if result =~ /^[1-6]{4}$/
      puts result
    end

    def you_win(result)
      puts "++++ (win)\n\n\t\t Congratulation!!!\nSecret code  #{result} one mote time?\n"
    end

    def you_loose(result)
      puts "You loose. The secret code was #{result}.\nOne more time? Y/n"
      input = gets.chomp.to_s.downcase
      case input
      when 'y' then play
      else menu
      end
    end

    def hint
      puts @game.hint
    end

    def exit
      abort 'Goodbye'
    end

    def unexpected_command_message
      puts 'Invalid values Please input: hint, exit or code'
    end

    def input_name
      puts 'Please input your name'
      name = gets.chomp
      return if name.equal?('exit')

      not_valid_name unless @game.name_check(name)
      name
    end

    def not_valid_name
      puts 'your name not valid, must be mor then 3 characters and less then 20'
      input_name
    end

    def choose_difficulty
      puts "Please choose difficulty:\n\tEasy\n\tMedium\n\tHell"
      difficulty = gets.chomp.to_sym.downcase
      return not_valid_difficulty unless @game.difficulty_check(difficulty)
      difficulty
    end

    def not_valid_difficulty
      puts 'difficulty not valid, must easy medium or hell'
      choose_difficulty
    end

    def stats
      Stats.show_stats(@game)
    end
  end
end
