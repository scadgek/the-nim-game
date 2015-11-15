import nimx.view
import nimx.image
import nimx.button
import nimx.context
import nimx.render_to_image
import nimx.animation
import nimx.window
import nimx.timer
import nimx.text_field

import math

import state

const
    stick_height = 20
    stick_width = 200
    stick_rounding = 10
    interstick_width = 100
    interstick_height = 10
    bottom_indent = 150
    top_indent = 100
    side_indent = 150
    num_columns = 3
    num_sticks = 15
    max_pick_sticks = 3
    min_pick_sticks = 1
    move_timeout = 1

type SticksView* = ref object of View
    image: Image

type Stick = tuple[x, y: float32, visible: bool]

type SticksMatrix = array[num_columns, array[num_sticks, Stick]]
var sticksMatrix: SticksMatrix

type Buttons = array[num_columns, array[min_pick_sticks..max_pick_sticks, Button]]
var allButtons: Buttons

proc disableAllButtons() =
  for i in 0..<num_columns:
    for j in min_pick_sticks..max_pick_sticks:
      allButtons[i][j].disable()

proc enableAllButtons() =
  for i in 0..<num_columns:
    if sticksMatrix[i][0].visible:
      for j in min_pick_sticks..max_pick_sticks:
        allButtons[i][j].enable()

proc canWin(): bool =
  var nonEmptyColumns = num_columns
  for i in 0..<num_columns:
    if not sticksMatrix[i][0].visible: dec(nonEmptyColumns)
  result = (nonEmptyColumns == 1)

proc randomNonEmptyColumn(): int =
  var count = 0
  result = random(num_columns)
  while count < num_columns:
    if sticksMatrix[result][0].visible:
      break
    result = (result + 1) mod num_columns
    inc(count)

proc checkEndGame(): bool =
  for i in 0..<num_columns:
    for j in 0..<num_sticks:
      if sticksMatrix[i][j].visible:
        return false
  return true

proc pickSticks(column, sticks: int) =
  var picked = 0
  for k in countdown(high(sticksMatrix[column]), low(sticksMatrix[column])):
    if sticksMatrix[column][k].visible:
        sticksMatrix[column][k].visible = false
        inc(picked)
    if picked >= sticks:
        break

method init*(v: SticksView, r: Rect) =
    procCall v.View.init(r)
    let label = newLabel(newRect(1100 div 2 - 50, 10, 100, 20))
    label.text = "Your move"
    v.addSubView(label)
    for i in 0..<num_columns:
        for j in 0..<num_sticks:
            var coordX = (side_indent + i * (stick_width + interstick_width)).toFloat
            var coordY = (650 - bottom_indent - j * (stick_height + interstick_height) - stick_height).toFloat
            var stick: Stick
            stick.x = coordX
            stick.y = coordY
            stick.visible = true
            sticksMatrix[i][j] = stick

    for i in 0..<num_columns:
        for j in min_pick_sticks..max_pick_sticks:
            let x = sticksMatrix[i][j].x + 50.toFloat
            let y = (650 - bottom_indent + 25 * j + 10 * (j - 1)).toFloat
            let column = i
            let sticks = j
            let button = newButton(newRect(x, y, 100, 25))
            button.title = "Pick " & $j & " sticks"
            button.onAction do():
              pickSticks(column, sticks)
              disableAllButtons()
              if checkEndGame():
                label.text = if currentPlayer() == Player:  "You win!" else: $currentPlayer() & "'s move"
              else:
                nextMove()
                label.text = if currentPlayer() == Player: "Your move" else: $currentPlayer() & "'s move"
              # computer move
              if not isGameOver():
                setTimeout(move_timeout.toFloat, proc =
                  let x = randomNonEmptyColumn()
                  let num = if canWin(): max_pick_sticks else: random(max_pick_sticks) + 1
                  pickSticks(x, num)
                  if checkEndGame():
                    label.text = if currentPlayer() == Player:  "You win!" else: $currentPlayer() & "'s move"
                  else:
                    nextMove()
                    label.text = if currentPlayer() == Player: "Your move" else: $currentPlayer() & "'s move"
                  enableAllButtons()
                  v.setNeedsDisplay()
                )
            v.addSubview(button)
            allButtons[i][j] = button

method draw(v: SticksView, r: Rect) =
    for i in 0..<num_columns:
        for j in 0..<num_sticks:
            let c = currentContext()
            c.fillColor = newColor(1, 1, 0)
            c.strokeColor = blackColor()
            c.strokeWidth = 3
            var coordX = (side_indent + i * (stick_width + interstick_width)).toFloat
            var coordY = (650 - bottom_indent - j * (stick_height + interstick_height) - stick_height).toFloat
            if sticksMatrix[i][j].visible:
                c.drawRoundedRect(newRect(sticksMatrix[i][j].x, sticksMatrix[i][j].y, stick_width, stick_height), stick_rounding)