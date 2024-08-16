extends Node2D
## Main screen canvas.
##
## This class represents the main screen canvas for the application. It is responsible 
## for initializing the window and setting up the main display parameters. This includes 
## configuring the window size and position to achieve specific visual effects, such as 
## a transparent application window.


func _ready():
	initialize_window()


## Initializes the window with the desired settings.
## This function configures the window size and position, allowing the application 
## to have a transparent window by adjusting the viewport dimensions.
func initialize_window() -> void:
	var window: Window = get_window()
	
	window.size = Vector2i(DisplayServer.screen_get_size() + Vector2i(1, 1))
	window.position = Vector2i(0, 0)
