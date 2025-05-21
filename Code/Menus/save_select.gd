extends Node2D

var level_select = "res://Scenes/Menus/level_select.tscn"
var grab = false

# Called when the node enters the scene tree for the first time.
func _ready():
	await SaveData.startup_finish
	load_data()

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

func load_data():
	var loop = 0
	for partida in SaveData.partidas:
		var timeLabel = get_node("background1/ScrollContainer/VBoxContainer/Partida"+str(loop+1)+"/VBoxContainer/HBoxContainer/saveGTime")
		var saveName = get_node("background1/ScrollContainer/VBoxContainer/Partida"+str(loop+1)+"/VBoxContainer/saveName")
		var buttonText = get_node("background1/ScrollContainer/VBoxContainer/Partida"+str(loop+1)+"/Button")
		
		if partida["tiempo_total"] == null:
			timeLabel.text = tr("TEXT_MENU_PLAYED_TIME") + " 00:00:00"
		else:
			var minutes = int(partida["tiempo_total"] / 60)
			var seconds = int(partida["tiempo_total"]) % 60
			var time = ("%02d" % minutes) + (":%02d" % seconds)
			timeLabel.text = tr("TEXT_MENU_PLAYED_TIME") + " " + time
		
		if partida["nueva"] == 1:
			saveName.text = tr("TEXT_MENU_NEW_SAVE")
			buttonText.text = tr("BUTTON_SAVE_NEW")
		else:
			saveName.text = tr("TEXT_MENU_SAVE_NAME")
			buttonText.text = tr("BUTTON_PLAY")
		
		loop += 1
