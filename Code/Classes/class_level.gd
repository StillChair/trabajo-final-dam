extends Node2D
class_name level

@export var id = 0
var points = 0
var start_time
var end_time
var time

func _ready():
	SceneManager.transition_start(Globals.FADE_TO_BLACK, true).finished.connect(start_timer)

func start_timer():
	start_time = Time.get_unix_time_from_system()

func calculate_time():
	end_time = Time.get_unix_time_from_system()
	time = end_time - start_time
	print("DEBUG | CALCULATED LEVEL BEAT TIME: " + str(time))
	return time
