extends Node2D

@onready var lvl_root = $"../.."
var level_data
var level_time

# Called when the node enters the scene tree for the first time.
func _ready():
	level_data = SaveData.datos_partida[lvl_root.id]
	#$AnimatedSprite2D.play("default")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		level_time = lvl_root.calculate_time()
		body.set_control(false)
		$AnimatedSprite2D.play("new_animation")
		await $AnimatedSprite2D.animation_finished
		$AnimationPlayer.play("level_beat")
		await  $AnimationPlayer.animation_finished
		if level_time < level_data["tiempo"] or level_data["tiempo"] == 0.0:
			print("DEBUG | BEAT BEST TIME: OLD -> "+str(level_data["tiempo"])+" | NEW -> "+str(level_time))
			$AnimationPlayer.play("time_beat")
			await $AnimationPlayer.animation_finished
			if lvl_root.points > level_data["puntos"]:
				$AnimationPlayer.play("score_beat")
				await $AnimationPlayer.animation_finished
		
		SceneManager.transition_start(Globals.FADE_TO_BLACK).finished.connect(end_level)

func end_level():
	if level_time < level_data["tiempo"] or level_data["tiempo"] == 0.0:
		if lvl_root.points > level_data["puntos"]:
			SaveData.save_level_beat(lvl_root.id, lvl_root.points, lvl_root.time)
		else:
			SaveData.save_level_beat(lvl_root.id, level_data["puntos"], lvl_root.time)
	else:
		if lvl_root.points > level_data["puntos"]:
			SaveData.save_level_beat(lvl_root.id, lvl_root.points, level_data["tiempo"])
		else:
			SaveData.save_level_beat(lvl_root.id, level_data["puntos"], level_data["tiempo"])
	SceneManager._load_scene("res://Scenes/Menus/level_select.tscn", 1.0)
