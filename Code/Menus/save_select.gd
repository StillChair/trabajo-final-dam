extends Node2D

var level_select = "res://Scenes/Menus/level_select.tscn"
var grab = false

# Called when the node enters the scene tree for the first time.
func _ready():
	await SaveData.startup_finish
	#if SaveData.partidas[0]["nueva"] == 1:
		#$background1/ScrollContainer/VBoxContainer/Partida1/VBoxContainer/saveName.text = "Partida vacia"
		#$background1/ScrollContainer/VBoxContainer/Partida1/Button.text = "Nueva"
	#if SaveData.partidas[1]["nueva"] == 1:
		#$background1/ScrollContainer/VBoxContainer/Partida2/VBoxContainer/saveName.text = "Partida vacia"
		#$background1/ScrollContainer/VBoxContainer/Partida2/Button.text = "Nueva"
	#if SaveData.partidas[2]["nueva"] == 1:
		#$background1/ScrollContainer/VBoxContainer/Partida3/VBoxContainer/saveName.text = "Partida vacía"
		#$background1/ScrollContainer/VBoxContainer/Partida3/Button.text = "Nueva"
	#if SaveData.partidas[0]["nueva"] == 0:
		#$background1/ScrollContainer/VBoxContainer/Partida1/VBoxContainer/saveName.text = "Partida 1"
		#$background1/ScrollContainer/VBoxContainer/Partida1/Button.text = "Jugar"
	#if SaveData.partidas[1]["nueva"] == 0:
		#$background1/ScrollContainer/VBoxContainer/Partida2/VBoxContainer/saveName.text = "Partida 2"
		#$background1/ScrollContainer/VBoxContainer/Partida2/Button.text = "Jugar"
	#if SaveData.partidas[2]["nueva"] == 0:
		#$background1/ScrollContainer/VBoxContainer/Partida3/VBoxContainer/saveName.text = "Partida 3"
		#$background1/ScrollContainer/VBoxContainer/Partida3/Button.text = "Jugar"
	var loop = 0
	var tiempo_total
	for partida in SaveData.partidas:
		if partida["tiempo_total"] == null:
			tiempo_total = 0
		else:
			tiempo_total = partida["tiempo_total"]
		
		var minutes = int(partida["tiempo_total"] / 60)
		var seconds = int(partida["tiempo_total"]) % 60
		var time = ("%02d" % minutes) + (":%02d" % seconds)
		var timeLabel = get_node("background1/ScrollContainer/VBoxContainer/Partida"+(loop+1)+"/VBoxContainer/HBoxContainer/saveGTime")
		var saveName = get_node("background1/ScrollContainer/VBoxContainer/Partida"+(loop+1)+"/VBoxContainer/saveName")
		var buttonText = get_node("background1/ScrollContainer/VBoxContainer/Partida"+(loop+1)+"/Button")
		timeLabel.text = "TEXT_MENU_PLAYED_TIME" + " time"
		if partida["nueva"] == 1:
			saveName.text = "TEXT_MENU_NEW_SAVE"
			buttonText.text = "BUTTON_SAVE_NEW"
		else:
			saveName.text = "TEXT_MENU_SAVE_NAME"
			buttonText.text = "BUTTON_PLAY"
		
		loop += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if grab == true:
		position = lerp(position, get_global_mouse_position(), 0.5)
	pass


func _on_button_pressed() -> void:
	SaveData.load_save(1)
	SceneManager._load_scene(level_select, 1.0)
	pass # Replace with function body.


func _on_button_2_pressed() -> void:
	SaveData.load_save(2)
	SceneManager._load_scene(level_select, 1.0)
	pass # Replace with function body.


func _on_button_3_pressed() -> void:
	SaveData.load_save(3)
	SceneManager._load_scene(level_select, 1.0)
	pass # Replace with function body.


func _on_grab_btn_button_down():
	grab = true
	pass # Replace with function body.


func _on_grab_btn_button_up():
	grab = false
	pass # Replace with function body.


func _on_close_btn_pressed():
	visible = false
	pass # Replace with function body.
