extends Control

func confetti():
	if SaveData.confetti == true:
		$confetti_green.emitting = true
		$confetti_red.emitting = true
		$confetti_yellow.emitting = true
		%beat_confetti_l/confetti_green.emitting = true
		%beat_confetti_l/confetti_red.emitting = true
		%beat_confetti_l/confetti_yellow.emitting = true
		%beat_confetti_r/confetti_green.emitting = true
		%beat_confetti_r/confetti_red.emitting = true
		%beat_confetti_r/confetti_yellow.emitting = true
		SaveData.confetti = false
