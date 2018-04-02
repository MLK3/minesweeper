require "test/unit"
require_relative "../src/Minesweeper"

class MinesweeperTest < Test::Unit::TestCase
  
  # 1 1 2 B 1
  # 2 B 3 1 1
  # 2 B 2 0 0
  def setup
    width, height, num_mines = 5, 3, 3
    @game = Minesweeper.new(width, height, num_mines, [[3,0], [1,1], [1,2]])
  end

  def test_initial_status

    expected = "112#1\n"\
               "2#311\n"\
               "2#200\n"
    assert_equal(expected, @game.board_state({full_xray: true}))
  end

  def test_play_1
    assert_equal(true,  @game.play(0, 0))

    expected = "1....\n"\
               ".....\n"\
               ".....\n"
    assert_equal(expected, @game.board_state)
  end

  def test_play_0
    assert_equal(true,  @game.play(3, 2))

    expected = ".....\n"\
               "..311\n"\
               "..200\n"
    assert_equal(expected, @game.board_state)
  end

  def test_explode
    @game.play(3, 0)
    assert_equal(false, @game.still_playing?)
    assert_equal(false, @game.victory?)
    assert_equal(false, @game.play(0, 0))
    assert_equal(false, @game.flag(1, 0))
  end

  def test_play_clicked_cell
    assert_equal(true,  @game.play(0, 0))
    assert_equal(false, @game.play(0, 0))
  end

  def test_play_flag_cell
    @game.flag(0, 0)
    assert_equal(false, @game.play(0, 0))
  end

  def test_flag
    assert_equal(true,  @game.flag(0, 0))
    expected = "F....\n"\
               ".....\n"\
               ".....\n"
    assert_equal(expected, @game.board_state)
  end

  def test_remove_flag
    assert_equal(true,  @game.flag(0, 0))
    assert_equal(true,  @game.flag(0, 0))
    expected = ".....\n"\
               ".....\n"\
               ".....\n"
    assert_equal(expected, @game.board_state)
  end

  def test_invalid_flag
    assert_equal(true,  @game.play(0, 0))
    assert_equal(false, @game.flag(0, 0))
  end

  def test_victory
    @game.play(0, 0)
    @game.play(0, 1)
    @game.play(0, 2)
    assert_equal(true,  @game.still_playing?)
    assert_equal(false, @game.victory?)
    @game.play(1, 0) 
    # (1,1) and (1,2) are bombs -> skip
    @game.play(2, 0)
    @game.play(2, 1)
    @game.play(2, 2)
    assert_equal(true,  @game.still_playing?)
    assert_equal(false, @game.victory?)
    # (3,0) is a bomb -> skip
    @game.play(3, 1) 
    @game.play(3, 2)
    assert_equal(true,  @game.still_playing?)
    assert_equal(false, @game.victory?)
    @game.play(4, 0)
    @game.play(4, 1)
    @game.play(4, 2)
    assert_equal(false, @game.still_playing?)
    assert_equal(true, @game.victory?)
  end

end