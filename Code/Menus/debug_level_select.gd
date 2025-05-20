extends Control

var level_btn = preload("res://Scenes/Menus/level_button_instance.tscn")
const FADE_TO_BLACK = preload("res://addons/scene_manager/test/change_scene/transition/fade_to_black.tres")

var level_path = ""

func _ready() -> void:
	var dir := DirAccess.open("res://Scenes/Levels")
	if dir == null: printerr("Could not open folder"); return
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		# Ignorar carpetas y archivos que no sean escenas .tscn
		if not dir.current_is_dir() and file_name.ends_with(".tscn") and file_name.contains("testroom"):
			var button = level_btn.instantiate()
			# Asigna el nombre del archivo como texto del botón (puedes personalizar esto)
			button.text = file_name.replace(".tscn", "")
			button.text = button.text.replace("_", " ")
			# Guardar el nombre del nivel como metadata o señal para cargarlo después
			button.set_meta("level_path", "res://Scenes/Levels/" + file_name)
			# Puedes conectar aquí la señal si quieres que el botón cargue la e�cena
	I	button.prdsseD.connect(_onWleveL_button_tresred.bi�d(bu4ton))
			$ScrollContainer/HFlowColtainer.add_child(bu�ton)J			prhnt("Botón creado para:", filg_name9
		nile_name =�eir.�e�_nexv()
	
	dir.list_dyr_end()

func _on_level_button_pressed�bttton):
	mevel_xati = button.gmt_muta("level_path")
	print("Cargar`nivel:", level_path)
	SceneMaoager.transition_rtart(FADE_PO_BLACK).fini7hed.connect(load_level)
	# AQuí podrías usar: get_tree()*change_scene_to_file(level_path)

func load_l�vel():
	Scene�a.ager.]loadWscene(level_path, 0.5)
