@tool
extends grabbable

@export var closable = false
@export_range(150.0, 350.0, 1.0) var height = 150.0
@export_range(150.0, 350.0, 1.0) var width = 150.0

func _process(delta):
	#Only shows in Editor
	if show_debug == false:
		if Engine.is_editor_hint():
			if movement_type == 0:
				$debug/Line2D.visible = false
				$debug/CollisionShape2D.visible = true
				$debug/CollisionShape2D.shape.radius = radius
				$debug/CollisionShape2D.position = position
			elif movement_type != 0:
				$debug/CollisionShape2D.visible = false
				$debug/Line2D.visible = true
				if movement_type == 1:
					$debug/Line2D.points[1].y = -y_range
					$debug/Line2D.points[1].x = 0.0
				elif movement_type == 2:
					$debug/Line2D.points[1].y = 0.0
					$debug/Line2D.points[1].x = x_range
			queue_redraw()
	else:
		if movement_type == 0:
			$debug/Line2D.visible = false
			$debug/CollisionShape2D.visible = true
			$debug/CollisionShape2D.shape.radius = radius
			$debug/CollisionShape2D.position = position
		elif movement_type != 0:
			$debug/Line2D.visible = true
			$debug/CollisionShape2D.visible = false
			if movement_type == 1:
				$debug/Line2D.points[1].y = -y_range
				$debug/Line2D.points[1].x = 0.0
			elif movement_type == 2:
				$debug/Line2D.points[1].y = 0.0
				$debug/Line2D.points[1].x = x_range
		queue_redraw()
	update_window()
	
	$NinePatchRect.position = Vector2(0.0, 0.0)
	$NinePatchRect.size.x = width
	$NinePatchRect.size.y = height
	
	if not Engine.is_editor_hint():
		
		if closable == true:
			$NinePatchRect/close_button.visible = true
		else:
			$NinePatchRect/close_button.visible = false
		
		if grab:
			if physics_item:
				freeze = true
			if disabled == false:
				if movement_type == 2:
					position.x = lerp(position.x, get_global_mouse_position().x, followspeed)
					position.x = clamp(position.x, placed_pos.x, placed_pos.x + x_range)
				elif movement_type == 1:
					position.y = lerp(position.y, get_global_mouse_position().y, followspeed)
					position.y = clamp(position.y, placed_pos.y - y_range, placed_pos.y)
				elif movement_type == 0:
					position = lerp(position, get_global_mouse_position(), followspeed)
					#position.x = clamp(position.x, placed_pos.x, placed_pos.x + x_range)
					#position.y = clamp(position.y, placed_pos.y - y_range, placed_pos.y)
		elif grab == false:
			if physics_item:
				freeze = false
			elif  physics_item == false:
				freeze = true
			if spring_back == true:
				#position = lerp(position, placed_pos, spring_back_force)
				position = position.move_toward(placed_pos, spring_back_force)
	
	

func update_window():
	var size = Vector2(width, height)
	var scale_factor = 0.5
	# Redimensionar correctamente con anchors centrados
	$NinePatchRect.offset_left = -width / 2
	$NinePatchRect.offset_right = width / 2
	$NinePatchRect.offset_top = 0
	$NinePatchRect.offset_bottom = height
	
	# Colisión principal
	var collision = $CollisionShape2D
	if collision and collision.shape is RectangleShape2D:
		var shape = collision.shape
		shape.extents = Vector2(width, height) / 2
		collision.scale = Vector2(scale_factor, scale_factor)
		collision.position = Vector2(width, height) * scale_factor / 2

	# Área de detección
	var detection = $player_detection_area/CollisionShape2D
	if detection and detection.shape is RectangleShape2D:
		var shape = detection.shape
		shape.extents = Vector2(width+40, height+40) / 2
		detection.scale = Vector2(scale_factor, scale_factor)
		detection.position = Vector2(width, height) * scale_factor / 2
	
	# Botón arriba a la derecha dentro del TextureRect
	var button = $Button
	if button:
		button.size.x = width - 20
	
	queue_redraw()
	#var current_center_x = position.x + size.x / 2
	#var current_top_y = position.y
#
	#size.x = width
	#size.y = height
	#position.x = current_center_x - width / 2
	#position.y = current_top_y  # Fijo arriba
#
	## Colisión principal
	#var collision = $CollisionShape2D
	#if collision and collision.shape is RectangleShape2D:
		#var shape = collision.shape
		#shape.extents = Vector2(width, height) / 2
		#var scale_factor = 0.5
		#collision.scale = Vector2(scale_factor, scale_factor)
		#collision.position = Vector2(width, height) * scale_factor / 2
#
	## Área de detección
	#var detection = $player_detection_area/CollisionShape2D
	#if detection and detection.shape is RectangleShape2D:
		#var shape = detection.shape
		#shape.extents = Vector2(width, height) / 2
		#var scale_factor = 0.5
		#detection.scale = Vector2(scale_factor, scale_factor)
		#detection.position = Vector2(width, height) * scale_factor / 2
	#
	## Botón arriba a la derecha dentro del TextureRect
	#var button = $Button
	#if button:
		#button.size = Vector2(width - 20, 40)
		#button.position = Vector2(10, 10)
#
	#queue_redraw()

func _on_close_btn_pressed():
	if closable:
		queue_free()
	else:
		pass
