require "test/unit"
require_relative "../src/Cell"

class CellTest < Test::Unit::TestCase

  def test_flag
    cell = Cell.new(0,0)
    assert_true cell.flag
    assert_true cell.has_flag?
    assert_true cell.flag
    assert_false cell.has_flag?
  end

  def test_click
    cell = Cell.new(0,0)
    assert_true cell.click
  end

  def test_click_flag
    cell = Cell.new(0,0)
    cell.flag
    assert_false cell.click
  end

  def test_flag_after_click
    cell = Cell.new(0,0)
    cell.click
    assert_false cell.flag
    assert_false cell.has_flag?
  end

  def test_click_twice
    cell = Cell.new(0,0)
    assert_true cell.click
    assert_false cell.click
  end

  def test_exploded
    cell = Cell.new(0,0)
    cell.has_bomb = true
    assert_false cell.exploded?
    cell.click
    assert_true cell.exploded?
  end

  def test_not_exploded
    cell = Cell.new(0,0)
    assert_false cell.exploded?
    cell.click
    assert_false cell.exploded?
  end

  def test_add_adj_bomb
    cell = Cell.new(0,0)
    assert_equal 0, cell.number_adj_bombs
    cell.add_adjacent_bomb        
    assert_equal 1, cell.number_adj_bombs
    cell.add_adjacent_bomb        
    assert_equal 2, cell.number_adj_bombs
  end

  def test_cell_state_clear
    cell = Cell.new(0,0)
    assert_equal ".", cell.cell_state
    cell.click
    assert_equal "0", cell.cell_state    
  end

  def test_cell_state_adj_bombs
    cell = Cell.new(0,0)
    cell.add_adjacent_bomb
    assert_equal ".", cell.cell_state
    cell.click
    assert_equal "1", cell.cell_state    
  end

  def test_cell_state_bomb
    cell = Cell.new(0,0)
    cell.has_bomb = true
    assert_equal ".", cell.cell_state
    cell.click
    assert_equal "#", cell.cell_state
  end

  def test_cell_state_flag
    cell = Cell.new(0,0)
    cell.flag
    assert_equal "F", cell.cell_state
    cell.has_bomb = true
    assert_equal "F", cell.cell_state
  end

  def test_cell_state_xray
    cell = Cell.new(0,0)
    cell.has_bomb = true
    assert_equal "#", cell.cell_state(xray: true)    
  end

  def test_cell_state_full_xray
    cell = Cell.new(0,0)
    cell.add_adjacent_bomb    
    assert_equal "1", cell.cell_state(full_xray: true)
  end

end