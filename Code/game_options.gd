extends Node

var lang : int = 1 # 0:English, 1:Spanish
var languages = {
	0:"en",
	1:"es",
}
var vol : float = 1.0 # Equivalent to 100%
var res : int = 0
var resolutions : Dictionary= {
	0:{"name":"1920 x 1080", "value":Vector2i(1920, 1080)},
	1:{"name":"1280 x 720", "value":Vector2i(1280, 720)},
	2:{"name":"1024 x 768", "value":Vector2i(1024, 768)},
	3:{"name":"800 x 600", "value":Vector2i(800, 600)},
}
var window_type = 0 # 0:Windowed, 1:Full
var firstTime = true

var config_path = "res://Data/config.ini"

func _ready() -> void:
	load_options()
	#change_win_size(res)
	set_screen(window_type)
	DisplayServer.window_set_max_size(Vector2i(1920, 1080))
	DisplayServer.window_set_min_size(Vector2i(800, 600))
	change_lang(lang)
	#change_win_size(res)

func load_options():
	var config_file := ConfigFile.new()
	var error = config_file.load(config_path)
	
	if error:
		print("An error happened while loading data: ", error)
		return
	
	lang = config_file.get_value("Game", "Language", 0)
	vol = config_file.get_value("Game", "Volume", 1.0)
	#res = config_file.get_value("Game", "Resolution", 1)
	window_type = config_file.get_value("Game", "Window", 0)

func change_win_size(resId):
	var win = get_window()
	win.set_size(resolutions[resId]["value"])
	#ProjectSettings.set_setting("display/window/size/viewport_width", resolutions[resId]["value"].x)
	#ProjectSettings.set_setting("display/window/size/viewport_height", resolutions[resId]["value"].y) 

func set_screen(mode):
	var win = get_window()
	match mode:
		1:
			ProjectSettings.set_setting("display/window/stretch/scale", 2.0)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		0:
			ProjectSettings.set_setting("display/window/stretch/scale", 1.0)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			#change_win_size(1)
	

func change_lang(lan):
	TranslationServer.set_locale(languages[lan])
