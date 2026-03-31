extends Control

@onready var texture_rect: TextureRect = $TextureRect

func _ready() -> void:
	visible = false # Hidden by default
	
	# Connect to the global unlocker
	if get_node_or_null("/root/VinesAbilityUnlocker"):
		var unlocker = get_node("/root/VinesAbilityUnlocker")
		unlocker.level_up.connect(_on_level_up)
		if unlocker.level >= 2:
			visible = true

func _on_level_up(new_level: int) -> void:
	if new_level >= 2:
		visible = true
