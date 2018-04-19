require_relative "../src/Minesweeper"
require_relative "../src/SimplePrinter"
require_relative "../src/ColorPrinter"

width, height, num_mines = 3, 3, 1
game = Minesweeper.new_game(width, height, num_mines)
printer = ColorPrinter.new
#printer = SimplePrinter.new

while game.still_playing?
  puts "De sua jogada (ou s para salvar ou l para carregar ou q para sair): "
  opcao = gets.chomp
  if opcao == 'q'
    exit(0)
  elsif opcao == 's'
    game.save
  elsif opcao == 'l'
    game = Minesweeper.load
    puts "Jogo carregado"
    printer.print(game.board_state)
  else
    x = opcao.to_i # se nenhuma opcao é escolhida, já é a jogada
    y = gets.to_i
    valid_move = game.play(x,y)
    if valid_move
      puts "Play (" << x.to_s << + "," + y.to_s + ")"
      printer.print(game.board_state)
    end
  end
end

puts "Fim do jogo!"
if game.victory?
  puts "Você venceu!"
else
  puts "Você perdeu! As minas eram:"
  printer.print(game.board_state(xray: true))
end