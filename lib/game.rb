require_relative 'board.rb'

class CheckersError < StandardError
end

class InvalidPieceError < CheckersError
end

class Game

  def initialize(red, white)
    @players = [red, white]
    @board = Board.new
  end

  def run
    until @board.lost?(@players.first.color)
      begin
        move_sequence = @players.first.get_move_sequence(@board)
        @board.perform_moves(move_sequence)
      rescue CheckersError => e
        puts e.message
        retry
      end
      
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
    @board = board
    moves = []
    puts board.render
    puts "#{color.to_s.capitalize}'s turn"
    moves << get_first_move

    get_subsequent_moves(moves)
  end

  def get_first_move
    puts "Which piece would you like to move?"
    start = gets.chomp.split(",").map(&:to_i)
    raise InvalidPieceError unless @board[start] &&
                                   @board[start].color == self.color

    puts "Where would you like to move it?"
    next_pos = gets.chomp.split(",").map(&:to_i)
    [start, next_pos]
  end

  def get_subsequent_moves(moves)
    puts "Move again? (y/n)"
    return moves if gets.chomp == "n"
    puts "Where would you like to move it?"
    while (input = gets.chomp)
      break if input == ""
      next_pos = input.split(",").map(&:to_i)
      move = [moves.last.last, next_pos]
      moves << move
      puts "Next move"
      puts "<enter> to stop"
    end

    moves
  end

end
