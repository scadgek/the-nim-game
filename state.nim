type Move = enum
  Player, Computer

var current_move*: Move
current_move = Player

proc nextMove*() =
  case current_move:
  of Player:
    current_move = Computer
  of Computer:
    current_move = Player
