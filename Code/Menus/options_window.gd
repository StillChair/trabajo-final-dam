extends Node2D

var grab = false
var file_path = "res://Data/config.ini"

# Called when the node enters the scene tree for the first time.
func _ready():
	$NinePatchRect/ScrollContainer/VBoxContainer/Language/langOpt.selected = GameOptions.lang
	$NinePatchRect/ScrollContainer/VBoxContainer/Volume/volSlider.value = GameOptions.vol
	$NinePatchRect/ScrollContainer/VBoxContainer/Resolution/OptionButton.selected = GameOptions.res
	$NinePatchRect/ScrollContainer/VBoxContainer/Window/OptionButton2.selected = GameOptions.window_type


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if grab:
		position = lerp(position, get_global_mouse_position(), 0.5)


func _on_grab_btn_button_down():
	grab = true


func _on_grab_btn_button_up():
	grab = false


func _on_close_btn_pressed() -> void:
	visible = false


func _on_save_btn_pressed() -> void:
	save_options()
	#GameOptions.change_win_size($NinePatchRect/ScrollContainer/VBoxContainer/Resolution/OptionButton.selected)
	GameOptions.set_screen($NinePatchRect/ScrollContainer/VBoxContainer/Window/OptionButton2.selected)
	GameOptions.change_lang($NinePatchRect/ScrollContainer/VBoxContainer/Language/langOpt.selected)
	pass # Replace with function body.

func save_options():
	var config = ConfigFile.new()
	
	#config.set_value("Game", "Language", GameOptions)
	config.set_value("Game", "Language", $NinePatchRect/ScrollContainer/VBoxContainer/Language/langOpt.selected)
	config.set_value("Game", "Volume", $NinePatchRect/ScrollContainer/VBoxContainer/Volume/volSlider.value)
	config.set_value("Game", "Window", $NinePatchRect/ScrollContainer/VBoxContainer/Window/OptionButton2.selected)
	
	var error = config.save(file_path)
	if error:
		print("An error happened while saving data: ", error)
