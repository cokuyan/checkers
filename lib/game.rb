require 'yaml'
require_relative 'board.rb'

class Game

  def initialize(red, white)
    @players = [red, white]
    @board = Board.new
  end

  def run
    until @board.lost?(@players.first.color)
      begin
        move_sequence = @players.first.get_move_sequence(@board)
        case move_sequence
        when :save then save; redo
        when :quit then return
        else @board.perform_moves(move_sequence)
        end
      rescue CheckersError => e
        puts e.message
        retry
      end
      @players.rotate!
    end
    puts "#{@players.last.color.to_s.capitalize} won!"
  end

  def save
    print "Enter filename: "
    filename = gets.chomp
    File.open(filename, 'w') { |file| file.write(self.to_yaml) }
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
    input = get_first_move
    return input if input.is_a?(Symbol)

    moves << input
    get_subsequent_moves(moves)
  end

  def get_first_move
    puts "Enter piece, 'save' to save, or 'quit' to quit"
    input = gets.chomp
    return input.to_sym if input == "save" || input == "quit"

    start = convert(input)
    raise InvalidPieceError unless @board[start] &&
                                   @board[start].color == self.color
    puts "Where would you like to move it?"
    next_pos = convert(gets.chomp)

    [start, next_pos]
  end

  def get_subsequent_moves(moves)
    puts "Move again? (y/n)"
    return moves if gets.chomp == "n"
    puts "Where would you like to move it?"
    while (input = gets.chomp)
      break if input == ""
      move = [moves.last.last, convert(input)]
      moves << move

      puts "Next move"
      puts "<enter> to stop"
    end

    moves
  end

  def convert(input)
    position = input.split("")
    first = position[0].ord - 'a'.ord
    second = 8 - Integer(position[1])

    [second, first]
  end

end
