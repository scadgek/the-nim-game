#!/usr/local/bin/nim c -r --noMain

import sticks_view

import nimx.sdl_window
import nimx.system_logger

proc startApplication() =
    var mainWindow : SdlWindow

    mainWindow.new()

    mainWindow.init(newRect(40, 40, 1100, 650))

    mainWindow.title = "The Nim Game"

    var currentView = SticksView.new(newRect(0, 0, 100, 100))
    currentView.setFrame(newRect(0, 0, mainWindow.bounds.width, mainWindow.bounds.height))
    currentView.autoresizingMask = { afFlexibleWidth, afFlexibleHeight }
    mainWindow.addSubview(currentView)

try:
    startApplication()
    runUntilQuit()
except:
    logi "Exception caught: ", getCurrentExceptionMsg()
    logi getCurrentException().getStackTrace()
