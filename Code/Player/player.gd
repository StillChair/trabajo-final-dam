extends CharacterBody2D


@export_group("Movement")
@export var maxspeed = 150.0
@export var jumpforce = -300.0
@export var accel = 5.0

@export_group("Camera")
@export var camera_deadzone = 150
var active = true
var enabled = true
var cursor_activated = false
var is_cursor_tangible = false
var warp_test = 0

@export var exit_to = "res://Scenes/Menus/main_menu.tscn"

# Game variables
var points = 0

func _ready():
	#if GameOptions.window_type == 1:
		#$Camera2D.zoom = Vector2(3.0, 3.0)
	#else:
		#$Camera2D.zoom = Vector2(2.0, 2.0)
	pass

func _process(delta):
	
	if active == true:
		# Exit when pressing ESC
		if Input.is_action_just_pressed("esc-exit"):
			SceneManager.transition_start(Globals.FADE_TO_BLACK).finished.connect(exit_level)
		
		
		
		# MOVEMENT
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta
		
		# Get player input
		var direction = Input.get_axis("a-left", "d-right")
		# If player is enabled -> Movement
		if enabled == true:
			# Jumping
			if Input.is_action_just_pressed("space-jump-accept") and is_on_floor():
				velocity.y = jumpforce
			
			# Movement based on direction + walk-stop animation
			if direction:
				if is_on_floor():
					$player_sprite.play("walk")
				velocity.x += direction * accel
			else:
				if is_on_floor():
					$player_sprite.play("idle")
				velocity.x = move_toward(velocity.x, 0, accel*3)
		else:
			velocity.x = move_toward(velocity.x, 0, accel*3)
			
		# Stop player from exceding maximum speed
		velocity.x = clampf(velocity.x, -maxspeed, maxspeed)
		#if velocity.x > maxspeed:
			#velocity.x = maxspeed
		#if velocity.x < -maxspeed:
			#velocity.x = -maxspeed
		
		# Mouse control
		if Input.is_action_pressed("ctrl-sp2"):
			cursor_activated = true
			enabled = false
			$player_sprite.play("transmit")
		if Input.is_action_just_released("ctrl-sp2"):
			cursor_activated = false
			enabled = true
		
		if cursor_activated == true:
			$Camera2D.cameraUpdate(camera_deadzone)
			$Camera2D.zoom = Vector2(2.5, 2.5)
		else:
			$Camera2D.zoom = Vector2(2.0, 2.0)
			$Camera2D.position = lerp($Camera2D.position, Vector2(0.0, 0.0), 0.25)
		
		
		if Input.is_action_just_pressed("r-reload"):
			SceneManager.transition_start(Globals.FADE_TO_BLACK).finished.connect(SceneManager.reload_current_scene)
		
		
		
		
		
		
		
		
		
		# ANIMATIONS
		if cursor_activated == false:
			$CanvasLayer/player_cur.modulate = "#a5a5a57d"
		else:
			$CanvasLayer/player_cur.modulate = "#ffffff"
		
		if direction < 0:
			$player_sprite.flip_h = true
		if direction > 0:
			$player_sprite.flip_h = false
	
	
	
	$debug/Label.text = str(warp_test)
	
	move_and_slide()

func set_control(value : bool):
	enabled = value

func set_actor_active(value : bool):
	active = value

func _on_cur_interaction_area_body_entered(body):
	pass # Replace with function body.

func exit_level():
	SceneManager._load_scene(exit_to, 0.5)
