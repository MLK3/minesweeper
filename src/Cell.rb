class Cell
    attr_reader :x
    attr_reader :y
    attr_writer :has_bomb
    attr_reader :number_adj_bombs
    
    def initialize(x, y)
        @x = x
        @y = y
        @number_adj_bombs = 0
        @uncovered = false
        @has_bomb = false
        @has_flag = false
    end

    def add_adjacent_bomb
      @number_adj_bombs += 1
    end

    def has_bomb?
      @has_bomb
    end

    def has_flag?
      @has_flag
    end

    def flag   
      valid = !@uncovered  
      @has_flag = !@has_flag if valid
      return valid
    end

    # Clica na célula e retorna se jogada foi válida
    # A jogada é válida somente se a célula ainda não foi descoberta e ainda não tem uma bandeira. 
    def click
      valid = (not @uncovered and not @has_flag)
      @uncovered = true if valid
      return valid
    end
 
    def exploded?
      return @uncovered && @has_bomb
    end

    def cell_state(options = {})
      
      xray = false
      full_xray = false
      if options.respond_to?("fetch") 
        xray = options.fetch(:xray, false)
        full_xray = options.fetch(:full_xray, false)
      end
      
      return "F" if @has_flag
      return "#" if @has_bomb and (xray or full_xray or @uncovered)
      return "." if not @uncovered and not full_xray
      return @number_adj_bombs.to_s
    end

    def to_s
        cell_state
    end
    
end