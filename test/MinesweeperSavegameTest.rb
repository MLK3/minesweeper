require "test/unit"
require_relative "../src/Minesweeper"

class MinesweeperSavegameTest < Test::Unit::TestCase
  
  def test_load
    game = Minesweeper.load("test/gamesave_test")

    expected = "000\n"\
               "111\n"\
               "...\n"
    assert_equal(expected, game.board_state)
    
    expected = "000\n"\
               "111\n"\
               "1#1\n"
    assert_equal(expected, game.board_state({full_xray: true}))

    assert_true(game.still_playing?)
    assert_false(game.victory?)
  end

  def test_savesetup
    gamesave_tmp = "gamesave_tmp"
    File.delete(gamesave_tmp) if File.exists?(gamesave_tmp)

    width, height, num_mines = 3, 3, 1
    game = Minesweeper.new_game(width, height, num_mines, [[1,2]])
    game.play(0,0)
    game.save(gamesave_tmp)

    assert_true(File.exists? gamesave_tmp)
    expected = IO.read("test/gamesave_test")
    actual = IO.read(gamesave_tmp)
    assert_equal(expected, actual)

    File.delete(gamesave_tmp)
  end

end