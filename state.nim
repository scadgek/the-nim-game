type Move = enum
  Player, Computer, GameOver

# not public, since it is unlikely to change game state directly
var current_move: Move
current_move = Player

proc nextMove*() =
  case current_move:
  of Player:
    current_move = Computer
  of Computer:
    current_move = Player
  else: discard

proc currentPlayer*(): Move =
  result = current_move

proc isGameOver*(): bool =
  result = (current_move == GameOver)