extends CanvasLayer

@onready var label: Label = $Label

func _ready() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.experience_changed.connect(_on_experience_changed)
		_update_label(player.experience)

func _on_experience_changed(new_exp: int) -> void:
	_update_label(new_exp)

func _update_label(exp_val: int) -> void:
	label.text = "XP: " + str(exp_val)
