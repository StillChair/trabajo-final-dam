extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_opt_btn_pressed():
	mainMenVis(false)
	optMenVis(true)
	pass # Replace with function body.

func mainMenVis(val):
	$main_menu.visible = val
func optMenVis(val):
	$option_menu.visible = val
