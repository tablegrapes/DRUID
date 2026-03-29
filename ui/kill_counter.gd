extends CanvasLayer

@onready var label: Label = $Label

func _ready() -> void:
	if GameManager:
		GameManager.kill_count_changed.connect(_on_kill_count_changed)
		_update_label(GameManager.kill_count)

func _on_kill_count_changed(new_count: int) -> void:
	_update_label(new_count)

func _update_label(count: int) -> void:
	label.text = "Kills: " + str(count)
