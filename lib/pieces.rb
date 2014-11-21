# encoding: utf-8
require 'colorize'
require_relative 'errors.rb'

class Piece

  attr_reader :pos, :color, :deltas

  def initialize(board, color, pos)
    @board, @color, @pos = board, color, pos

    board.place_piece(self, @pos)
    @promoted = false
  end

  def dup(board)
    new_piece = Piece.new(board, color, pos)
    new_piece.promote if promoted?
    new_piece
  end

  def valid_moves
    all_moves = moves(:slide) + moves(:jump)
    all_moves.select { |move| perform_slide(move) || perform_jump(move) }
  end

  def perform_slide(slide_pos)
    return false unless valid_slide_pos?(slide_pos)

    @board.remove_piece(pos)
    @pos = slide_pos
    @board.place_piece(self, slide_pos)
    promote if promotable? && !promoted?
    true
  end

  def perform_jump(jump_pos)
    return false unless valid_jump_pos?(jump_pos)
    adjacent_pos = adjacent_pos(jump_pos)

    @board.remove_piece(pos)
    @board.remove_piece(adjacent_pos)
    @board.place_piece(self, jump_pos)
    @pos = jump_pos
    promote if promotable? && !promoted?
    true
  end

  def render
    symbol = promoted? ? "🅚 " : "⬤ "
    symbol.colorize(color)
  end


  private

  def moves(move)
    multiplier = move == :slide ? 1 : 2
    x, y = pos
    moves = move_diffs.map do |dx, dy|
      [x + dx * multiplier, y + dy * multiplier]
    end
    moves.select { |move| @board.on_board?(move) }
  end

  def move_diffs
    diffs = [[1, 1], [1, -1]]
    diffs += diffs.map{ |row| [row.first * -1, row.last] } if promoted?
    diffs.map! { |row| [row.first * -1, row.last] } if color == :white
    diffs
  end

  def adjacent_pos(jump_pos)
    [(pos.first + jump_pos.first) / 2, (pos.last + jump_pos.last) / 2]
  end

  def valid_slide_pos?(slide_pos)
    moves(:slide).include?(slide_pos) && @board[slide_pos].nil?
  end

  def valid_jump_pos?(jump_pos)
    adjacent_pos = adjacent_pos(jump_pos)

    moves(:jump).include?(jump_pos) &&
    @board[adjacent_pos] &&
    @board[jump_pos].nil? &&
    @board[adjacent_pos].color != self.color
  end

  protected

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

end
