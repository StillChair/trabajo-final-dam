extends ParallaxLayer

func _process(delta: float) -> void:
		self.motion_offset.x += -10 * delta
