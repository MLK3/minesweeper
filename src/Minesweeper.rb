require_relative 'Cell'
require 'set'

# Engine para o jogo Minesweeper
class Minesweeper

  attr_reader :board

  def initialize(width, height, num_mines, mines_positions = nil)
    
    if width <= 0 or height <=0 or num_mines > width * height
      raise ArgumentError.new("Invalid parameters to initialize Minesweeper game")
    end

    # Cria o board
    @board = Array.new(height) { Array.new(width) }
    (0..height-1).each do |row|
      (0..width-1).each do |col|              
        @board[row][col] = Cell.new(col, row)                
      end
    end
   
    # Usa posicoes especificadas para as minas ou sorteia
    mines = nil
    if mines_positions.respond_to?(:each)
      mines = mines_positions
    else
      mines = Set.new
      until mines.size == num_mines
        mines.add([rand(width),rand(height)])
      end
    end

    # Posiciona as bombas
    mines.each do |pos|
      cell = @board[pos[1]][pos[0]]        
      cell.has_bomb = true
      for_each_neighbor(cell) { |cell_n| cell_n.add_adjacent_bomb }
    end
    
    @exploded = false
  end

  private def for_each_neighbor(cell) 
    # Define range x e y dos vizinhos respeitando os limites do board
    range_x = ([0,cell.x-1].max .. [cell.x+1,@board[cell.y].size-1].min)
    range_y = ([0,cell.y-1].max .. [cell.y+1,@board.size-1].min)
    range_y.each do |yi| 
      range_x.each do |xi| 
        yield(@board[yi][xi]) unless @board[yi][xi] == cell
      end
    end
  end
    
  # Retorna true se o jogo ainda está em andamento, 
  # ou false se o jogador tiver alcançado a condição de vitória ou de derrota
  def still_playing?
    not (@exploded or victory?)
  end

  # Recebe as coordenadas x e y do tabuleiro e clica na célula correspondente; a célula passa a ser "descoberta". 
  # Retorna um booleano informando se a jogada foi válida. 
  # A jogada é válida somente se a célula selecionada ainda não foi clicada e ainda não tem uma bandeira. 
  # Caso a célula clicada seja válida, não tenha uma bomba e seja vizinha de zero bombas, 
  # todos os vizinhos sem bomba e sem bandeira daquela célula também devem ser descobertas, 
  # e devem seguir esta mesma lógica para seus próprios vizinhos
  def play(x, y)

    return false if @exploded

    cell = @board[y][x]
    valid = cell.click
    @exploded = cell.exploded?
    
    expand(cell) if not @exploded 
    
    return valid
  end

  private def expand(cell)
  
    cell.click
    if cell.number_adj_bombs == 0
      for_each_neighbor(cell) do |cell_n| 
        expand(cell_n) if not (cell_n.uncovered or cell.has_bomb? or cell.has_flag?)
      end
    end
  end

  # Adiciona uma bandeira a uma célula ainda não descoberta ou remove a bandeira preexistente de uma célula. 
  # Retorna um booleano informando se a jogada foi válida.
  def flag(x, y)    
    @board[y][x].flag
  end

  # Retorna true somente se o jogo já acabou e o jogador ganhou
  # i.e, todas as células sem bomba foram descobertas
  def victory?
    not @board.flatten.any? { |cell| not cell.uncovered and not cell.has_bomb?}
  end

  # Retorna o estado atual do tabuleiro, com as linhas separadas por '\n'
  # e de acordo com o seguinte formato:
  # Célula não-descoberta: '.',  
  # Bomba: '#',
  # Bandeira: 'F',
  # Célula sem bomba: número de 0 a 8, indicando o número de células vizinhas com bomba
  # Se o cliente passar o hash {xray: true} como parâmetro, deve indicar a localização de todas as bombas.
  def board_state(options = {})
    board_state = String.new
    @board.each do |row|
        row.each do |cell|
          board_state << cell.cell_state(options)
        end
        board_state << "\n"
    end
    return board_state    
  end

end
