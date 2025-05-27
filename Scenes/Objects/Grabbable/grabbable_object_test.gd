extends RigidBody2D

var grab = false
var followspeed = 0.1

func _process(delta: float) -> void:
	if grab == true:
		freeze = true
		position = lerp(position, get_global_mouse_position(), followspeed)
	else:
		freeze = false
	
	

func _on_button_button_down():
	grab = true
	pass # Replace with function body.


func _on_button_button_up():
	grab = false
	pass # Replace with function body.
