require 'codebreaker/game'
module ShowStats
  def self.show_stats(game)
    if game.statistic.empty?
      puts 'no stats data'
    else
      print_table(game)
    end
  end

  def self.print_table(game)
    format = '%-8s %-8s %-15s %-15s %-15s %-15s %s'
    puts format(format, 'Rating', 'Name', 'Difficulty', 'Attempts Total', 'Attempts Used', 'Hints Total',
                'Hints Used')
    i = 0
    game.statistic.each do |player|
      puts format(format, i += 1, player.name, player.difficulty, player.attempts_total, player.attempts_used,
                  player.hints_total, player.hints_used)
    end
  end
end