extends Control

var stop = false

# Called when the node enters the scene tree for the first time.
func _ready():
	SceneManager.transition_start(Globals.FADE_TO_BLACK, true)
	if stop == false:
		$VBoxContainer.position.y = 300
	if $VBoxContainer.position.y <= -520.0:
		stop = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$VBoxContainer.position.y -= 0.7
	if Input.is_action_just_pressed("esc-exit"):
		exit_to_menu()
	pass


func _on_timer_timeout():
	exit_to_menu()
	pass # Replace with function body.

func exit_to_menu():
	await SceneManager.transition_start(Globals.FADE_TO_BLACK).finished
	SceneManager._load_scene("res://Scenes/Menus/main_menu.tscn", 0.5)
