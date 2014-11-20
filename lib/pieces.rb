# encoding: utf-8
require_relative 'board.rb' #just in case

class CheckersError < StandardError; end
class InvalidMoveError < CheckersError
  def message
    "Invalid Move"
  end
end

class Piece

  # may remove later
  # iterate over it twice for king positions also
  DELTAS = [
    [1, 1],
    [1, -1]
  ]

  attr_reader :pos, :color, :deltas

  def initialize(board, color, pos)
    @board, @color, @pos = board, color, pos
    @deltas = if @color == :white
                DELTAS.map { |row| [row.first * -1, row.last] }
              else
                DELTAS
              end


    board.place_piece(self, @pos)
    @promoted = false
  end

  def dup(board)
    new_piece = Piece.new(board, color, pos)
    new_piece.promote if promoted?
    new_piece
  end

  def move_diffs
    if promoted?
      @deltas + @deltas.map{ |row| [row.first * -1, row.last] }
    else
      @deltas
    end
  end

  def moves(move)
    move_diffs
    multiplier = move == :slide ? 1 : 2
    x, y = pos
    moves = @deltas.map { |dx, dy| [x + dx * multiplier, y + dy * multiplier] }
    moves.select { |x, y| x.between?(0,7) && y.between?(0,7) }
  end

  def valid_moves
    all_moves = moves(:slide) + moves(:jump)
    all_moves.select { |move| perform_slide(move) || perform_jump(move) }
  end

  def perform_slide(slide_pos)
    return false unless moves(:slide).include?(slide_pos) &&
                        @board[slide_pos].nil?

    @board.remove_piece(pos)
    @pos = slide_pos
    @board.place_piece(self, slide_pos)
    promote if promotable? && !promoted?
    true
  end

  def perform_jump(jump_pos)
    adjacent_pos = [(pos.first + jump_pos.first) / 2,
                    (pos.last + jump_pos.last) / 2]

    return false unless moves(:jump).include?(jump_pos) &&
                        @board[adjacent_pos] &&
                        @board[jump_pos].nil? &&
                        @board[adjacent_pos].color != self.color

    @board.remove_piece(pos)
    @board.remove_piece(adjacent_pos)
    @board.place_piece(self, jump_pos)
    @pos = jump_pos
    promote if promotable? && !promoted?
    true
  end

  def promote
    @promoted = true
  end

  def promoted?
    @promoted
  end

  def promotable?
    row = pos.first

    color == :white ? row == 0 : row == 7
  end

  def render
    color == :white ? "w" : "r"
    # not promoted: ◯, with colorize
    # promoted: Ⓚ
  end

end
