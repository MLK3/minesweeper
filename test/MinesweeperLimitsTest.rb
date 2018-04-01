require "test/unit"
require_relative "../src/Minesweeper"

class MinesweeperLimitsTest < Test::Unit::TestCase
  
  def test_zero_mines
    width, height, num_mines = 3, 2, 0
    game = Minesweeper.new(width, height, num_mines)
    game.play(0,0)
    assert_equal(false, game.still_playing?)
    assert_equal(true,  game.victory?)
  end

  def test_full_mines
    width, height, num_mines = 1, 1, 1
    game = Minesweeper.new(width, height, num_mines)
    game.flag(0,0)
    assert_equal(false, game.still_playing?)
    assert_equal(true,  game.victory?)
  end

  def test_more_mines_than_possible
    width, height, num_mines = 2, 2, 5
    assert_raise ArgumentError do
      Minesweeper.new(width, height, num_mines)
    end
  end

  def test_invalid_width
    width, height, num_mines = 0, 2, 0
    assert_raise ArgumentError do
      Minesweeper.new(width, height, num_mines)
    end
  end

end