require_relative './lib/game.rb'

puts "Welcome to Checkers"
puts "Would you like to load a game? (y/n)"
if gets.chomp == "y"
  print "Enter filename: "
  file = File.read(gets.chomp)
  game = YAML.load(file)
else
  game = Game.new(HumanPlayer.new(:red), HumanPlayer.new(:white))
end

game.run
