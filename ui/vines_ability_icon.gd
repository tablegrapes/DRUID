extends Control

@onready var texture_rect: TextureRect = $TextureRect

func _ready() -> void:
	print("Vines icon script ready")
	# Hide initially, then check player level
	visible = false
	
	# Find the player in the scene
	var player = get_tree().get_first_node_in_group("player")
	if player:
		print("Player found in ready")
		_setup_player(player)
	else:
		print("Player not found in ready, waiting for node_added")
		get_tree().node_added.connect(_on_node_added)

func _on_node_added(node: Node) -> void:
	if node.is_in_group("player"):
		print("Player found via node_added")
		_setup_player(node)
		if get_tree().node_added.is_connected(_on_node_added):
			get_tree().node_added.disconnect(_on_node_added)

func _setup_player(player: Node) -> void:
	print("Setting up player. Current level: ", player.level)
	if player.level >= 2:
		visible = true
		print("Vines icon visible set to true (setup)")
	
	if not player.level_up.is_connected(_on_level_up):
		player.level_up.connect(_on_level_up)
	
	_update_tooltip(player)

func _on_level_up(new_level: int) -> void:
	print("Player leveled up to: ", new_level)
	if new_level >= 2:
		visible = true
		print("Vines icon visible set to true (level up)")
	
	var player = get_tree().get_first_node_in_group("player")
	if player:
		_update_tooltip(player)

func _update_tooltip(player: Node) -> void:
	var x_snare_duration = 2.0 # Default
	var y_lifetime = 2.5 # Default
	
	# Check if vines_scene is set
	if player.get("vines_scene"):
		var vines_instance = player.vines_scene.instantiate()
		x_snare_duration = vines_instance.snare_duration
		y_lifetime = vines_instance.lifetime
		vines_instance.free()
	
	var z_cast_time = player.get("vines_cast_time")
	if z_cast_time == null:
		z_cast_time = 0.5
	
	var cd = player.get("vines_cooldown_duration")
	if cd == null:
		cd = 10.0
	
	texture_rect.tooltip_text = "-- Entangling Vines -- \nGrasping vines sprout from all around the Druid. \nEnemies caught in the vines will be unable to move for %s seconds. \nThe vines last for %s seconds. \nCast Time: %s seconds \nCooldown: %s seconds" % [str(x_snare_duration), str(y_lifetime), str(z_cast_time), str(cd)],
