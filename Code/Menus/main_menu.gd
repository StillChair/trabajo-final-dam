extends Menu

func _ready():
	SaveData.startup()
	await SaveData.startup_finish
	SceneManager.transition_start(Globals.FADE_TO_BLACK, true)

func _process(delta: float) -> void:
	if Input.is_action_pressed("a-left") and Input.is_action_pressed("d-right") and Input.is_action_pressed("ctrl-sp2") and Input.is_action_pressed("r-reload"):
		menu_load = "res://Scenes/Menus/level_select.tscn"
		SceneManager.transition_start(Globals.FADE_TO_BLACK).finished.connect(load_menu)

func _on_play_btn_pressed():
	$CanvasLayer/save_select.load_data()
	$CanvasLayer/save_select.visible = true


func _on_opt_btn_pressed():
	#menu_load = options
	#SceneManager.transition_start(FADE_TO_BLACK).finished.connect(load_menu)
	set_visibility($CanvasLayer/options_window, true)


func _on_exit_btn_pressed():
	SceneManager.transition_start(Globals.FADE_TO_BLACK).finished.connect(exit_game)

func exit_game():
	# WIP
	print("Game exited")
	get_tree().quit()


func _on_debug_btn_pressed():
	menu_load = play_test
	SceneManager.transition_start(Globals.FADE_TO_BLACK).finished.connect(load_menu)


func _on_credit_btn_pressed():
	menu_load = credits
	await  SceneManager.transition_start(Globals.FADE_TO_BLACK).finished
	SceneManager._load_scene("res://Scenes/Menus/credits.tscn", 0.5)
	pass # Replace with function body.
