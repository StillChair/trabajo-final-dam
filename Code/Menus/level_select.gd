extends Control

var level_btn = preload("res://Scenes/Menus/level_button_instance.tscn")
var folder

var level_path = ""
var nivel_index = 0

func _ready() -> void:
	SceneManager.transition_start(Globals.FADE_TO_BLACK, true).finished.connect($beat_confetti.confetti)
	
	if OS.has_feature("standalone"):
		folder = OS.get_executable_path().get_base_dir()
	else:
		folder = "res://Scenes/"
	
	var dir := DirAccess.open(folder+"Levels")
	if dir == null: printerr("Could not open folder"); return
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		# Ignorar carpetas y archivos que no sean escenas .tscn
		if not dir.current_is_dir() and file_name.ends_with(".tscn") and not (file_name.contains("testroom") or file_name.contains("template")):
			var button = level_btn.instantiate()
			# Asigna el nombre del archivo como texto del botón (puedes personalizar esto)
			button.text = file_name.replace(".tscn", "")
			button.text = button.text.replace("_", " ")
			button.text = button.text.replace("lvl", "")
			# Guardar el nombre del nivel como metadata o señal para cargarlo después
			button.set_meta("level_path", "res://Scenes/Levels/" + file_name)
			# Comprobar
			if SaveData.datos_partida.size() > nivel_index and SaveData.datos_partida[nivel_index]["desbloqueado"] == 1:
				button.disabled = false
				button.pressed.connect(_on_level_button_pressed.bind(button))
			else:
				button.disabled = true  # Bloquea el botón si no está desbloqueado
			# Puedes conectar aquí la señal si quieres que el botón cargue la escena
			button.pressed.connect(_on_level_button_pressed.bind(button))
			$ScrollContainer/HFlowContainer.add_child(button)
			print("Botón creado para:", file_name)
			nivel_index += 1
		file_name = dir.get_next()
	
	dir.list_dir_end()

func _on_level_button_pressed(button):
	level_path = button.get_meta("level_path")
	print("Cargar nivel:", level_path)
	SceneManager.transition_start(Globals.FADE_TO_BLACK).finished.connect(load_level)
	# Aquí podrías usar: get_tree().change_scene_to_file(level_path)

func load_level():
	SceneManager._load_scene(level_path, 0.5)

func _process(delta):
	if Input.is_action_just_pressed("esc-exit"):
		SceneManager.transition_start(Globals.FADE_TO_BLACK).finished.connect(exit_to_menu)

func exit_to_menu():
	SceneManager._load_scene("res://Scenes/Menus/main_menu.tscn", 0.5)
