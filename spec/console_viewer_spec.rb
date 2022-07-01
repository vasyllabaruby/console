# frozen_string_literal: true

require_relative 'console/console_viewer'

RSpec.describe Console::ConsoleViewer do
  let(:console_viewer) { Console::ConsoleViewer.new }

  context '#welcome' do
    let(:console_viewer_mock) { instance_double 'Console::ConsoleViewer.new' }
    it 'welcome method print as expected' do
      allow(console_viewer).to receive_message_chain(:menu).and_return('menu')
      expect { console_viewer.send(:welcome) }.to output("Welcome!!!\n").to_stdout
    end
  end

  context '#menu' do
    it 'gets start' do
      allow(console_viewer).to receive_message_chain(:gets, :chomp).and_return('start', 'exit')
      allow(console_viewer).to receive_message_chain(:play).and_return('')
      expect { console_viewer.send(:menu) }.to output("Please input command: \n\tstart\n\trules\n\tstats\n\texit
Please input command: \n\tstart\n\trules\n\tstats\n\texit\nGoodbye\n").to_stdout
    end

    it ' gets rules' do
      allow(console_viewer).to receive_message_chain(:gets, :chomp).and_return('rules', 'exit')
      expect { console_viewer.send(:menu) }.to output("Please input command: \n\tstart\n\trules\n\tstats\n\texit
Codebreaker is a logic game in which a code-breaker tries to break a secret code created by a code-maker. The codemaker,
which will be played by the application we’re going to write, creates a secret code of four numbers between 1 and 6.

The codebreaker gets some number of chances to break the code (depends on chosen difficulty). In each turn, the
codebreaker makes a guess of 4 numbers. The codemaker then marks the guess with up to 4 signs - + or - or empty spaces.

A + indicates an exact match: one of the numbers in the guess is the same as one of the numbers in the secret code
and in the same position. For example:
Secret number - 1234
Input number - 6264
Number of pluses - 2 (second and fourth position)

A - indicates a number match: one of the numbers in the guess is the same as one of the numbers in the secret code but
in a different position. For example:
Secret number - 1234
Input number - 6462
Number of minuses - 2 (second and fourth position)

An empty space indicates that there is not a current digit in a secret number.

If codebreaker inputs the exact number as a secret number - codebreaker wins the game. If all attempts are spent
- codebreaker loses.

Codebreaker also has some number of hints(depends on chosen difficulty). If a user takes a hint - he receives back a
separate digit of the secret code.
Please input command: \n\tstart\n\trules\n\tstats\n\texit\nGoodbye
").to_stdout
    end

    it ' gets stats' do
      player1 = Codebreaker::Player.new('Tester')
      player1.difficulty = ('hell')
      player1.attempts_total = 5
      player1.hints_total = 1
      player1.instance_variable_set(:@attempts_used, 3)
      player1.instance_variable_set(:@hints_used, 0)
      player2 = Codebreaker::Player.new('Naruto')
      player2.difficulty = ('easy')
      player2.attempts_total = 15
      player2.hints_total = 2
      player2.instance_variable_set(:@attempts_used, 8)
      player2.instance_variable_set(:@hints_used, 1)
      console_viewer.game.instance_variable_set(:@statistic, [player1, player2])
      allow(console_viewer).to receive_message_chain(:gets, :chomp).and_return('stats', 'exit')
      expect { console_viewer.send(:menu) }.to output("Please input command: \n\tstart\n\trules\n\tstats\n\texit
Rating   Name     Difficulty      Attempts Total  Attempts Used   Hints Total     Hints Used
1        Tester   hell            5               3               1               0
2        Naruto   easy            15              8               2               1
Please input command: \n\tstart\n\trules\n\tstats\n\texit\nGoodbye
").to_stdout
    end

    it ' gets exit' do
      allow(console_viewer).to receive_message_chain(:gets, :chomp).and_return('exit')
      expect do
        console_viewer.send(:menu)
      end.to output("Please input command: \n\tstart\n\trules\n\tstats\n\texit\nGoodbye\n").to_stdout
    end

    it 'gets invalid command' do
      allow(console_viewer).to receive_message_chain(:gets, :chomp).and_return('Invalid command', 'exit')
      expect { console_viewer.send(:menu) }.to output("Please input command: \n\tstart\n\trules\n\tstats\n\texit
You have passed unexpected command. Please choose one from listed commands
Please input command: \n\tstart\n\trules\n\tstats\n\texit\nGoodbye\n").to_stdout
    end
  end

  context '#input_name' do
    it 'print as expected' do
      allow(console_viewer).to receive_message_chain(:gets, :chomp).and_return('exit')
      expect { console_viewer.send(:input_name) }.to output("Please input your name\n").to_stdout
    end
  end

  context '#not_valid_name' do
    it 'print as expected' do
      allow(console_viewer).to receive_message_chain(:input_name).and_return(nil)
      expect do
        console_viewer.send(:not_valid_name)
      end.to output("your name not valid, must be mor then 3 characters and less then 20\n").to_stdout
    end
  end

  context '#choose_difficulty' do
    it 'print as expected' do
      allow(console_viewer).to receive_message_chain(:gets, :chomp).and_return('Hell')
      expect do
        console_viewer.send(:choose_difficulty)
      end.to output("Please choose difficulty:\n\tEasy\n\tMedium\n\tHell\n").to_stdout
    end
  end

  context '#not_valid_difficulty' do
    it 'print as expected' do
      allow(console_viewer).to receive_message_chain(:choose_difficulty).and_return(nil)
      expect do
        console_viewer.send(:not_valid_difficulty)
      end.to output("difficulty not valid, must easy medium or hell\n").to_stdout
    end
  end

  context '#stats' do
    it 'print as expected when no data' do
      console_viewer.game.instance_variable_set(:@statistic, [])
      expect { console_viewer.send(:stats) }.to output("no stats data\n").to_stdout
    end
  end

  context '#unexpected_command_message' do
    it 'print as expected' do
      expect do
        console_viewer.send(:unexpected_command_message)
      end.to output("Invalid values Please input: hint, exit or code\n").to_stdout
    end
  end

  context '#hint' do
    it 'print as expected' do
      console_viewer.game.instance_variable_set(:@hints_list, ['1'])
      expect { console_viewer.send(:hint) }.to output("1\n").to_stdout
    end
  end

  context '#you_win' do
    it 'print as expected' do
      expect do
        console_viewer.send(:you_win,
                            '1111')
      end.to output("++++ (win)\n\n\t\t Congratulation!!!\nYou win!!! one mote time?\n").to_stdout
    end
  end

  context '#you_loose' do
    it 'print as expected gets n' do
      allow(console_viewer).to receive_message_chain(:gets, :chomp).and_return('n')
      allow(console_viewer).to receive_message_chain(:menu).and_return('')
      expect do
        console_viewer.send(:you_loose,
                            '1111')
      end.to output("You loose. The secret code was 1111.\nOne more time? Y/n\n").to_stdout
    end

    it 'print as expected gets Y' do
      allow(console_viewer).to receive_message_chain(:gets, :chomp).and_return('Y')
      allow(console_viewer).to receive_message_chain(:play).and_return('')
      expect do
        console_viewer.send(:you_loose,
                            '1111')
      end.to output("You loose. The secret code was 1111.\nOne more time? Y/n\n").to_stdout
    end
  end

  context '#result' do
    it 'print as expected if win' do
      game_mock = instance_double('Game', play: '++++')
      console_viewer.instance_variable_set(:@game, game_mock)
      expect do
        console_viewer.send(:result,
                            '1111')
      end.to output("++++ (win)\n\n\t\t Congratulation!!!\nYou win!!! one mote time?\n++++\n").to_stdout
    end

    it 'print as expected if loose' do
      allow(console_viewer).to receive_message_chain(:gets, :chomp).and_return('n')
      allow(console_viewer).to receive_message_chain(:menu).and_return('')
      game_mock = instance_double('Game', play: '1111')
      console_viewer.instance_variable_set(:@game, game_mock)
      expect do
        console_viewer.send(:result,
                            '2222')
      end.to output("You loose. The secret code was 1111.\nOne more time? Y/n\n1111\n").to_stdout
    end
  end

  context '#play' do
    it 'print as expected' do
      allow(console_viewer).to receive_message_chain(:make_step).and_return('')
      allow(console_viewer).to receive_message_chain(:input_name).and_return('Tester')
      allow(console_viewer).to receive_message_chain(:choose_difficulty).and_return(:easy)

      expect { console_viewer.send(:play) }.to output("\n\t\tGame started   !!!!\n").to_stdout
    end
  end
end
