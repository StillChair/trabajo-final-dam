extends Control
class_name Menu

const main = "res://Scenes/Menus/main_menu.tscn"
const options = "res://Scenes/Menus/option_menu.tscn"
const saves = "res://Scenes/Menus/save_select.tscn"
const play_test = "res://Scenes/Levels/lvl_01_testroom_1.tscn"
const credits = "res://Scenes/Menus/credits.tscn"

var menu_load = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	SceneManager.transition_start(Globals.FADE_TO_BLACK, true)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func load_menu():
	SceneManager.transition_start(Globals.FADE_TO_BLACK).finished.connect(switch_scene)

func set_visibility(object, value):
	object.visible = value

func switch_scene():
	SceneManager._load_scene(menu_load, 0.5)
