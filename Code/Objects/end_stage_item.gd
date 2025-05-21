extends Node2D

@onready var lvl_root = $"../.."
const FADE_TO_BLACK = preload("res://addons/scene_manager/test/change_scene/transition/fade_to_black.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("default")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		body.set_control(false)
		SceneManager.transition_start(FADE_TO_BLACK).finished.connect(end_level)

func end_level():
	SaveData.save_level_beat(lvl_root.id)
	SceneManager._load_scene("res://Scenes/Menus/level_select.tscn", 1.0)
	pass
