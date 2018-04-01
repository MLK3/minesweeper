class ColorPrinter

  def print(board_state)
    lines = board_state.split("\n")
    lines.each do |line|
      str_line = "|"
      line.chars.each do |cell|
        str_line << color_cell(cell) << "|"
      end      
      puts(str_line)
    end
  end

  def color_cell(cell)
    case cell
    when '.'
      color(' ', 44) #bg blue
    when '#'
      color(cell, 41) #bg red
    when 'F'
      color(cell, 43) #bg brown
    when '0'
      color(' ', 40) # bg black
    else
      cell
    end
  end

  def color(str, color_code)
    "\e[#{color_code}m#{str}\e[0m"
  end

  def bg_blue(str)
    color(str, 44)
  end

end