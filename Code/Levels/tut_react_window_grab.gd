extends RichTextLabel

@onready var parent = $".."

func _process(delta: float) -> void:
	if parent.grab == true:
		self.text = tr("TEXT_TUT_WIN_GRAB")
	elif parent.grab == false:
		self.text = tr("TEXT_TUT_WIN_NOTGRAB")
