class CheckersError < StandardError
end

class InvalidPieceError < CheckersError
  def message
    "Please choose a position with your piece on it"
  end
end

class InvalidMoveSequenceError < CheckersError
  def message
    "Invalid Move Sequence"
  end
end

class NoMovesGivenError < CheckersError
  def message
    "No moves were given"
  end
end

class OffBoardError < CheckersError
end

class InvalidMoveError < CheckersError
  def message
    "Invalid Move"
  end
end
