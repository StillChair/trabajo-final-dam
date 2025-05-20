extends Menu

@onready var save_win = $confirm_window
var save_path = "user://score.save"

var saved = true



func _on_exit_menu_btn_pressed():
	menu_load = main
	SceneManager.transition_start(FADE_TO_BLACK).finished.connect(load_menu)

func save_options():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(saved)

func load_saved():
	if FileAccess.file_exists(save_path):
		print("file found")
		var file = FileAccess.open(save_path, FileAccess.READ)
		saved = file.get_var()
