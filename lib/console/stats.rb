# frozen_string_literal: true

module Console
  # Module to print stats
  module Stats
    def self.show_stats(game)
      if game.statistic.empty?
        puts 'no stats data'
      else
        print_table(game)
      end
    end

    def self.print_table(game)
      format = '%-8s %-8s %-15s %-15s %-15s %-15s %s'
      puts format(format, 'Rating', *Codebreaker::Player::HEADING)
      i = 0
      game.statistic.each do |player|
        puts format(format, i += 1, *player.rows)
      end
    end
  end
end
