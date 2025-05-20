extends CharacterBody2D

const speed = 125.0


func _physics_process(delta):
	
	var direction = Input.get_vector("a-left", "d-right", "w-up", "s-down")
	velocity = direction * speed
	
	
	
	
	
	
	
	move_and_slide()
