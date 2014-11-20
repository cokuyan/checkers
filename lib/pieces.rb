class Piece

  # may remove later
  # iterate over it twice for king positions also
  DELTAS = [
    [1, 1]
    [1, -1]
  ]

  attr_reader :pos, :color

  def intialize(board, pos, color)
    @board, @pos, @color = board, pos, color

    board.place_piece(self, @pos)
    @promoted = false
  end


  def perform_slide(slide_pos)
    return false unless @board[slide_pos].nil?
    @board.remove_piece(pos)
    @pos = slide_pos ##### Put this into board class?
    #### when placing a piece, remove it from board in old position?
    @board.place_piece(self, slide_pos)
    promote if promotable? && !promoted?
    true
  end

  def perform_jump(jump_pos)
    adjacent_pos = [(pos.first + jump_pos.first) / 2,
                    (pos.last + jump_pos.last) / 2]

    return false unless @board[adjacent_pos] && @board[jump_pos].nil?

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

    color == :white ? row == 7 : row == 0
  end

end
