extends TextureButton

func _ready() -> void:
	visible = false # Hidden by default
	
	_update_tooltip()
	
	mouse_entered.connect(_on_mouse_entered)
	
	# Try to find the player and connect to its level_up signal
	var players = get_tree().get_nodes_in_group("player")
	var player: Node = null
	if players.size() > 0:
		player = players[0]
	else:
		# Search for any CharacterBody2D
		var cb2ds = get_tree().root.find_children("*", "CharacterBody2D", true, false)
		if cb2ds.size() > 0:
			player = cb2ds[0]
	
	if player:
		print("AbilityVinesUI: Connected to player ", player.name)
		if player.has_signal("level_up"):
			player.level_up.connect(_on_level_up)
		
		# Check current level
		if "level" in player and player.level >= 2:
			visible = true
	else:
		print("AbilityVinesUI: Player not found at ready")

func _on_mouse_entered() -> void:
	print("AbilityVinesUI: Mouse entered! Tooltip is: ", tooltip_text)

func _update_tooltip() -> void:
	# Default values
	var w: float = 2.0
	var x: int = 2
	var y: float = 2.5
	var z: float = 0.5
	
	# Fetch values from vines.gd
	var vines_script = load("res://scripts/vines.gd")
	if vines_script:
		var vines_instance = vines_script.new()
		if vines_instance:
			if "snare_duration" in vines_instance: w = vines_instance.snare_duration
			if "damage" in vines_instance: x = vines_instance.damage
			if "lifetime" in vines_instance: y = vines_instance.lifetime
			vines_instance.free()
	
	# Fetch cast time from player.gd
	var player_script = load("res://scripts/player.gd")
	if player_script:
		var player_instance = player_script.new()
		if player_instance:
			if "vines_cast_time" in player_instance:
				z = player_instance.vines_cast_time
			player_instance.free()
	
	var tooltip_format = "Entangling Vines -- Vines sprout in all directions from the Druid, preventing enemies from moving for %s seconds, and dealing %s damage. The vines last for %s seconds. Cast Time: %s seconds"
	tooltip_text = tooltip_format % [str(w), str(x), str(y), str(z)]
	
	print("AbilityVinesUI: Tooltip updated: ", tooltip_text)

func _on_level_up(new_level: int) -> void:
	if new_level >= 2:
		visible = true
