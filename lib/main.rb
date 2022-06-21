require_relative 'console/console_viewer'
module Console
  class Main
    include Codebreaker
    console = ConsoleViewer.new
    console.welcome
  end
end
