extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func cameraUpdate(deadzone):
	var pos = get_local_mouse_position()
	#if pos.x >= -deadzone and pos.x < deadzone:
		#position = lerp(position, pos, 0.25)
	position = lerp(position, pos, 0.25)
