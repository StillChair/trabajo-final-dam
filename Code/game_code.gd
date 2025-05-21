extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Start game")
	SceneManager._load_scene("res://Scenes/Menus/saving_warning.tscn", 1.0)
	#SceneManager._load_scene("res://Scenes/Menus/main_menu.tscn", 1.0)
	#Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
