class Board

  def self.create_board
    Array.new(8) { Array.new(8) }
  end

  def initialize
    @grid = Board.create_board

    setup_grid
  end

  def [](pos)
    raise OffBoardError unless pos.all? { |i| i.between?(0, 7) }

    x, y = pos
    @grid[x][y]
  end

  def []=(pos, piece)
    raise OffBoardError unless pos.all? { |i| i.between?(0, 7) }

    x, y = pos
    @grid[x][y] = piece
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
