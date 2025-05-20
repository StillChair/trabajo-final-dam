@tool
extends RigidBody2D
class_name grabbable

@export var physics_item = true ## Controls if the object has physics when not grabbed
@export_enum("Free", "Linear Y", "Linear X") var movement_type = 0 ## Controls if object only follows mouse through one axis
@export_range(0.0, 1000.0, 10.0) var y_range = 50.0 ## Range of linear y-axis movement
@export_range(0.0, 1000.0, 10.0) var x_range = 50.0 ## Range of linear x-axis movement
@export_range(0.01, 1000.0) var radius = 50.0 ## Radius of free movement allowed
@export var spring_back = false ## Controls if object goes back to position 0 when letting go (If linear enabled)
@export_range(0.5, 2.0, 0.1) var spring_back_force = 1.0 ## Speed at which object springs back to original position
@export var followspeed = 0.1 ## Speed at which object catches up with mouse
@export var show_debug = false
var grab = false
var disabled = false
var toprange = global_position
var placed_pos

# Called when the node enters the scene tree for the first time.
func _ready():
	placed_pos = position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Only shows in Editor
	if show_debug == false:
		if Engine.is_editor_hint():
			if movement_type == 0:
				$Line2D.visible = false
			elif movement_type != 0:
				$Line2D.visible = true
				if movement_type == 1:
					$Line2D.points[1].y = -y_range
					$Line2D.points[1].x = 0.0
				elif movement_type == 2:
					$Line2D.points[1].y = 0.0
					$Line2D.points[1].x = x_range
			queue_redraw()
	else:
		if movement_type == 0:
			$Line2D.visible = false
		elif movement_type != 0:
			$Line2D.visible = true
			if movement_type == 1:
				$Line2D.points[1].y = -y_range
				$Line2D.points[1].x = 0.0
			elif movement_type == 2:
				$Line2D.points[1].y = 0.0
				$Line2D.points[1].x = x_range
		queue_redraw()
	
	
	
	if grab:
		if physics_item:
			freeze = true
		if disabled == false:
			if movement_type == 2:
				position.x = lerp(position.x, get_global_mouse_position().x, followspeed)
				if position.x > x_range:
					position.x = lerp(position.x, placed_pos.x+x_range, followspeed*5)
				if position.x < 0:
					position.x = lerp(position.x, placed_pos.x, followspeed*5)
			elif movement_type == 1:
				position.y = lerp(position.y, get_global_mouse_position().y, followspeed)
			elif movement_type == 0:
				position = lerp(position, get_global_mouse_position(), followspeed)
	else:
		if physics_item:
			freeze = false
		elif  physics_item == false:
			freeze = true
		if spring_back == true:
			position = lerp(position, placed_pos, spring_back_force)


func _on_button_button_down():
	grab = true
	pass # Replace with function body.


func _on_button_button_up():
	grab = false
	pass # Replace with function body.

func _on_player_detection_area_body_entered(body):
	if body.is_in_group('Player'):
		disabled = true


func _on_player_detection_area_body_exited(body):
	if body.is_in_group('Player'):
		disabled = false
	pass # Replace with function body.
