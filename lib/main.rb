# frozen_string_literal: true

require_relative 'console/console_viewer'
module Console
  # Main class to run the game
  class Main
    include Codebreaker
    console = ConsoleViewer.new
    console.welcome
  end
end
