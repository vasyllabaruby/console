require_relative 'console/console_viewer'
# Docs rof Test class
class Test
  include Codebreaker
  console = ConsoleViewer.new
  console.welcome
end
