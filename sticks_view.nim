import nimx.view
import nimx.image
import nimx.context
import nimx.render_to_image

const
    stick_height = 20
    stick_width = 200
    stick_rounding = 10
    interstick_width = 100
    interstick_height = 10
    bottom_indent = 50
    top_indent = 100
    side_indent = 200

type SticksView* = ref object of View
    image: Image

type Stick = tuple[x, y: float32, visible: bool]

type SticksMatrix = array[0..2, array[0..14, Stick]]

method draw(v: SticksView, r: Rect) =
    var sticksMatrix: SticksMatrix
    for i in 0..2:
        for j in 0..14:
            let c = currentContext()
            c.fillColor = newColor(1, 1, 0)
            c.strokeColor = blackColor()
            c.strokeWidth = 3
            var coordX = (side_indent + i * (stick_width + interstick_width)).toFloat
            var coordY = (600 - bottom_indent - j * (stick_height + interstick_height) - stick_height).toFloat
            c.drawRoundedRect(newRect(coordX, coordY, stick_width, stick_height), stick_rounding)