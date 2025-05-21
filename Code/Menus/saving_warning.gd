extends Control

const FADE_TO_BLACK = preload("res://addons/scene_manager/test/change_scene/transition/fade_to_black.tres")

func _ready() -> void:
	SceneManager.transition_start(FADE_TO_BLACK, true)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("space-jump-accept"):
		SceneManager.transition_start(FADE_TO_BLACK,false).finished.connect(proceed)

func proceed():
	SceneManager.change_scene_to_file("res://Scenes/Menus/main_menu.tscn")
