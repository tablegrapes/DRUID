extends CanvasLayer

@onready var label: Label = $Label

func _ready() -> void:
	if GameManager:
		GameManager.experience_changed.connect(_on_experience_changed)
		_update_label(GameManager.experience)

func _on_experience_changed(new_exp: int) -> void:
	_update_label(new_exp)

func _update_label(exp_val: int) -> void:
	label.text = "XP: " + str(exp_val)
