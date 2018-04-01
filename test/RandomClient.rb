require_relative "../src/Minesweeper"
require_relative "../src/SimplePrinter"
require_relative "../src/ColorPrinter"

width, height, num_mines = 20, 5, 10
game = Minesweeper.new(width, height, num_mines)
printer = ColorPrinter.new

while game.still_playing?
  x, y = rand(width), rand(height)
  valid_move = game.play(x,y)
  valid_flag = game.flag(rand(width), rand(height))  
  if valid_move or valid_flag
    puts "Play (" << x.to_s << + "," + y.to_s + ")"
    printer.print(game.board_state)
  end
end

puts "Fim do jogo!"
if game.victory?
  puts "Você venceu!"
else
  puts "Você perdeu! As minas eram:"
  ColorPrinter.new.print(game.board_state(xray: true))
end