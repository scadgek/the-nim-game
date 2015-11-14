import nimx.view
import nimx.image
import nimx.context
import nimx.render_to_image

const
    stick_height = 20
    stick_width = 200
    stick_rounding = 10



type SticksView* = ref object of View
    image: Image

proc renderToImage(): Image =
    result = imageWithSize(newSize(200, 100))
    result.draw do():
        let c = currentContext()
        c.fillColor = newColor(1, 1, 0)
        c.strokeColor = blackColor()
        c.strokeWidth = 3
        c.drawRoundedRect(newRect(0, 0, stick_width, stick_height), stick_rounding)

method draw(v: SticksView, r: Rect) =

    let c = currentContext()
    c.fillColor = newColor(1, 1, 0)
    c.strokeColor = blackColor()
    c.strokeWidth = 3
    c.drawRoundedRect(newRect(0, 0, stick_width, stick_height), stick_rounding)