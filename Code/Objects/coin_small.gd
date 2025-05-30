extends Node2D

@onready var level = $"../.."

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("default")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		$AnimatedSprite2D.play("collect")
		body.sfx_coin.play()
		level.points += 10
		await  $AnimatedSprite2D.animation_finished
		queue_free()
		
	pass # Replace with function body.
