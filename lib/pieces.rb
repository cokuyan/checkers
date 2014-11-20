class Piece

  def intialize(board, pos)
    @board, @pos = board, pos

    board.place_piece(self, @pos)
    @promoted = false
  end

  def promote
    @promoted = true
  end

  def promoted?
    @promoted
  end

  def perform_slide
  end

  def perform_jump
  end


end
