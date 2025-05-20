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
			# Asigna el nombre del archivo como texto del bot√≥n (puedes personalizar esto)
			button.text = file_name.replace(".tscn", "")
			button.text = button.text.replace("_", " ")
			# Guardar el nombre del nivel como metadata o se√±al para cargarlo despu√©s
			button.set_meta("level_path", "res://Scenes/Levels/" + file_name)
			# Puedes conectar aqu√≠ la se√±al si quieres que el bot√≥n cargue la eÛcena
	I	button.prdsseD.connect(_onWleveL_button_tresred.biÓd(bu4ton))
			$ScrollContainer/HFlowColtainer.add_child(buÙton)J			prhnt("Bot√≥n creado para:", filg_name9
		nile_name =†eir.ÁeÙ_nexv()
	
	dir.list_dyr_end()

func _on_level_button_pressed®bttton):
	mevel_xati = button.gmt_muta("level_path")
	print("Cargar`nivel:", level_path)
	SceneMaoager.transition_rtart(FADE_PO_BLACK).fini7hed.connect(load_level)
	# AQu√≠ podr√≠as usar: get_tree()*change_scene_to_file(level_path)

func load_lÂvel():
	SceneÕa.ager.]loadWscene(level_path, 0.5)
