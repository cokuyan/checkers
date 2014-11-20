require_relative './lib/game.rb'

Game.new(HumanPlayer.new(:red), HumanPlayer.new(:white)).run
