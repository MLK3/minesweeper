require "test/unit"
require_relative "../src/Minesweeper"

class MinesweeperUnitTest < Test::Unit::TestCase

  def setup
    width, height, num_mines = 5, 3, 3
    @game = Minesweeper.new(width, height, num_mines, [[3,0], [1,1], [1,2]])
  end

  def test_for_each_neighbor
    neighbors = Array.new
    @game.for_each_neighbor(@game.board[1][1]) { |cell| neighbors << cell }
    assert_equal 8, neighbors.size
  end

  def test_for_each_neighbor_top_left_corner
    neighbors = Array.new
    @game.for_each_neighbor(@game.board[0][0]) { |cell| neighbors << cell }
    assert_equal 3, neighbors.size
  end

  def test_for_each_neighbor_bottom_right_corner
    neighbors = Array.new
    @game.for_each_neighbor(@game.board[2][4]) { |cell| neighbors << cell }
    assert_equal 3, neighbors.size
  end

end