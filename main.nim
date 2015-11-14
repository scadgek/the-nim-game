#!/usr/local/bin/nim c -r --noMain

import nimx.sdl_window
import nimx.system_logger

proc startApplication() =
    var mainWindow : SdlWindow

    mainWindow.new()

    mainWindow.init(newRect(40, 40, 800, 600))

    mainWindow.title = "The Nim Game"

try:
    startApplication()
    runUntilQuit()
except:
    logi "Exception caught: ", getCurrentExceptionMsg()
    logi getCurrentException().getStackTrace()
