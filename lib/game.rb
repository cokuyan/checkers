require_relative 'board.rb'

class Game

  def initialize(red, white)
    @players = [red, white]
    @board = Board.new
  end

  def run
    until @board.done?
      move_sequence = @players.first.get_move_sequence(@board)
      @board.perform_moves(move_sequence)
      @players.rotate!
    end

    #winning message
  end

end


class HumanPlayer

  attr_reader :color

  def initialize(color)
    @color = color
  end

  def get_move_sequence(board)
    moves = []
    puts board.render
    puts "Which piece would you like to move?"
    start = gets.chomp.split(",").map(&:to_i)
    puts "Where would you like to move it?"
    next_pos = gets.chomp.split(",").map(&:to_i)
    move = [start, next_pos]
    moves << move
  

 #maybe use Integer instead to cast?
    moves
  end

end
