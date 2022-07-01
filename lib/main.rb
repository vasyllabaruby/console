# frozen_string_literal: true

require_relative 'console/console_viewer'
module Console
  # Main class to run the game
  class Main
    console = ::Codebreaker::ConsoleViewer.new
    console.welcome
  end
end
