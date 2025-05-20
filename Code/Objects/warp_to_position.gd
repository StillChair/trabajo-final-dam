extends Node2D

const FADE_TO_BLACK = preload("res://addons/scene_manager/test/change_scene/transition/fade_to_black.tres")
@export var destination_position = Vector2()
@export var automatic = false

var player_in = false
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_in == true and Input.is_action_just_pressed("e-interact"):
		player.set_control(false)
		SceneManager.transition_start(FADE_TO_BLACK).finished.connect(warp_to)


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		player_in = true
		if automatic == true:
			body.set_control(false)
			SceneManager.transition_start(FADE_TO_BLACK).finished.connect(warp_to)
	pass # Replace with function body.


func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		player_in = false


func warp_to():
	player.position = destination_position
