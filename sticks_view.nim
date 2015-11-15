import nimx.view
import nimx.image
import nimx.button
import nimx.context
import nimx.render_to_image
import nimx.animation
import nimx.window

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

type SticksView* = ref object of View
    image: Image

type Stick = tuple[x, y: float32, visible: bool]

type SticksMatrix = array[num_columns, array[num_sticks, Stick]]
var sticksMatrix: SticksMatrix

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
            let x = sticksMatrix[i][j].x + toFloat(50)
            let y = (650 - bottom_indent + 25 * j + 10 * (j - 1)).toFloat
            let button = newButton(newRect(x, y, 100, 25))
            button.title = "Pick " & $j & " sticks"
            let column = i
            let sticks = j
            button.onAction do():
                pickSticks(column, sticks)

            v.addSubview(button)

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