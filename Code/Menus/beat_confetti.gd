extends Node2D

func _ready() -> void:
	if SaveData.confetti == true:
		$confetti_green.emitting = true
		$confetti_red.emitting = true
		$confetti_yellow.emitting = true
