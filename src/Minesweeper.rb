require_relative 'Cell'

class Minesweeper

  attr_reader :board

  def initialize(width, height, num_mines, mines_positions = nil)
    
    @still_playing = true
    @victory = false

    @board = Array.new(height) { Array.new(width) }
    (0..height-1).each do |row|
      (0..width-1).each do |col|              
        @board[row][col] = Cell.new(col, row)                
      end
    end

    # Posiciona as bombas
    if mines_positions.respond_to?(:each)
      mines_positions.each do |pos|
        cell = @board[pos[1]][pos[0]]        
        cell.has_bomb = true
        for_each_neighbor(cell) { |cell_n| cell_n.add_adjacent_bomb }
      end
    end
  end

  def for_each_neighbor(cell) 
    # Define range x e y dos vizinhos respeitando os limites do board
    range_x = ([0,cell.x-1].max .. [cell.x+1,@board[cell.y].size-1].min)
    range_y = ([0,cell.y-1].max .. [cell.y+1,@board.size-1].min)
    range_y.each do |yi| 
      range_x.each do |xi| 
        yield(@board[yi][xi]) unless @board[yi][xi] == cell
      end
    end
  end
    

  def still_playing?
    @still_playing
  end

  def play(x, y)
    cell = @board[y][x]
    valid = cell.click
    @still_playing = !cell.exploded?

    if @still_playing and valid and cell.number_adj_bombs == 0
      for_each_neighbor(cell) { |cell_n| expand(cell_n) }
    end

    puts board_state(true) << "\n"
    return valid
  end

  def expand(cell)

    return if cell.has_bomb? or cell.has_flag?
    valid = cell.click
    if valid and cell.number_adj_bombs == 0
      for_each_neighbor(cell) { |cell_n| expand(cell_n) }      
    end
  end

  def flag(x, y)
    cell = @board[y][x]
    cell.flag
  end

  def check_victory
    @board.
  end

  def victory?
      false
  end

  def board_state(options = {})    
    s = String.new
    @board.each do |row|
        row.each do |cell|
            s << cell.cell_state(options)
        end
        s << "\n"
    end
    return s    
  end

end


if __FILE__ == $0

  require_relative 'SimplePrinter'

  width, height, num_mines = 3, 3, 1
  game = Minesweeper.new(width, height, num_mines, [[1,0]])
  
  game.play(0,2)
  
end

