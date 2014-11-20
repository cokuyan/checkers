require_relative 'board.rb' #just in case

class CheckersError < StandardError; end
class InvalidMoveError < CheckersError; end

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
    @deltas.map { |dx, dy| [x + dx * multiplier, y + dy * multiplier] }
  end

  def perform_slide(slide_pos)
    slide_pos.each_index do |i|
      raise InvalidMoveError unless moves(:slide).include?(slide_pos)
    end
    return false unless @board[slide_pos].nil?
    @board.remove_piece(pos)
    @pos = slide_pos ##### Put this into board class?
    #### when placing a piece, remove it from board in old position?
    @board.place_piece(self, slide_pos)
    promote if promotable? && !promoted?
    true
  end

  def perform_jump(jump_pos)
    jump_pos.each_index do |i|
      raise InvalidMoveError unless moves(:jump).include?(jump_pos)
    end
    adjacent_pos = [(pos.first + jump_pos.first) / 2,
                    (pos.last + jump_pos.last) / 2]

    return false unless @board[adjacent_pos] &&
                        @board[jump_pos].nil? &&
                        @board[adjacent_pos].color != self.color

    @board.remove_piece(pos)
    @board.remove_piece(adjacent_pos)
    @board.place_piece(self, jump_pos)
    @pos = jump_pos ### same note as perform_slide
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
  end

end
