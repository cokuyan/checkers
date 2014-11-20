require_relative 'pieces.rb'

class Board

  def self.create_board
    Array.new(8) { Array.new(8) }
  end

  def initialize(setup = true)
    @grid = Board.create_board
    setup_grid if setup
  end

  def [](pos)
    raise OffBoardError unless on_board?(pos)

    x, y = pos
    @grid[x][y]
  end

  def []=(pos, piece)
    raise OffBoardError unless on_board?(pos)

    x, y = pos
    @grid[x][y] = piece
  end

  def on_board?(pos)
    pos.all? { |i| i.between?(0, 7) }
  end

  def perform_moves(move_sequence)
    raise InvalidMoveSequenceError unless valid_move_seq?(move_sequence)
    perform_moves!(move_sequence)
  end

  def valid_move_seq?(move_sequence)
    test_board = self.dup
    begin
      test_board.perform_moves!(move_sequence)
    rescue InvalidMoveSequenceError
      return false
    end
    true
  end

  # move sequence is an array of moves, each move is an array of positions
  def perform_moves!(move_sequence)
    raise NoMovesGivenError if move_sequence.empty?
    move_sequence.each_with_index do |move, i|
      from_pos = move.first
      to_pos   = move.last
      piece = self[from_pos]

      slid = piece.perform_slide(to_pos) if i.zero?
      if !i.zero? || (i.zero? && !slid)
        jumped = piece.perform_jump(to_pos)
      end
      raise InvalidMoveSequenceError unless slid || jumped
    end
  end

  def place_piece(piece, pos)
    self[pos] = piece
  end

  def remove_piece(pos)
    self[pos] = nil
  end

  def lost?(color)
    test_board = self.dup
    test_board.pieces.none? { |piece| piece.color == color } ||
    test_board.pieces.select { |piece| piece.color == color }
                       .all? { |piece| piece.valid_moves.empty? }
  end

  def pieces
    @grid.flatten.reject(&:nil?)
  end

  def dup
    test_board = Board.new(false)

    @grid.each_index do |row|
      @grid[row].each_with_index do |piece, col|
        pos = [row,col]
        piece = self[pos]
        test_board[pos] = piece ? piece.dup(test_board) : nil
      end
    end

    test_board
  end

  def render
    @grid.map.with_index do |row, i|
      row.map.with_index do |piece, j|
        space = piece ? piece.render : "  "
        (i + j).odd? ? space.on_light_black : space
      end.join
    end
  end

  def setup_grid
    # white: 5,6,7
    5.upto(7) do |row|
      place_row(row, :white)
    end
    # red: 0,1,2
    0.upto(2) do |row|
      place_row(row, :red)
    end
  end

  def place_row(row, color)
    8.times do |col|
      next if (row + col).even?
      Piece.new(self, color, [row, col])
    end
  end

end
