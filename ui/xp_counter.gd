extends CanvasLayer

@onready var label: Label = $Label

func _ready() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.experience_changed.connect(_on_experience_changed)
		player.level_up.connect(_on_level_up)
		_update_label(player.level, player.experience, player.experience_to_next_level)

func _on_experience_changed(current_exp: int, next_level_exp: int) -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player:
		_update_label(player.level, current_exp, next_level_exp)

func _on_level_up(new_level: int) -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player:
		_update_label(new_level, player.experience, player.experience_to_next_level)

func _update_label(lvl: int, exp_val: int, next_exp: int) -> void:
	label.text = "Level: %d | XP: %d / %d" % [lvl, exp_val, next_exp]
