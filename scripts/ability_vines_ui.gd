extends TextureButton

var player_node: CharacterBody2D = null

func _ready() -> void:
	visible = false # Hidden by default
	mouse_entered.connect(_on_mouse_entered)
	_find_and_setup_player()
	_update_tooltip()

func _find_and_setup_player() -> void:
	var players = get_tree().get_nodes_in_group("player")
	var found_player: CharacterBody2D = null
	if players.size() > 0:
		found_player = players[0]
	else:
		# Search for any CharacterBody2D
		var cb2ds = get_tree().root.find_children("*", "CharacterBody2D", true, false)
		if cb2ds.size() > 0:
			found_player = cb2ds[0]

	if found_player:
		player_node = found_player
		print("AbilityVinesUI: Connected to player ", found_player.name)
		if found_player.has_signal("level_up"):
			found_player.level_up.connect(_on_level_up)
		
		# Check current level
		if "level" in found_player and found_player.level >= 2:
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
	var cooldown: float = 10.0
	
	# Fetch values from vines.gd
	var vines_script = load("res://scripts/vines.gd")
	if vines_script:
		var vines_instance = vines_script.new()
		if vines_instance:
			if "snare_duration" in vines_instance:
				w = vines_instance.snare_duration
			if "damage" in vines_instance:
				x = vines_instance.damage
			if "lifetime" in vines_instance:
				y = vines_instance.lifetime
			vines_instance.free()
	
	# Fetch cast time and cooldown from the player, if available
	if player_node:
		if "vines_cast_time" in player_node:
			z = player_node.vines_cast_time
		if "vines_cooldown_duration" in player_node:
			cooldown = player_node.vines_cooldown_duration
	else:
		var player_script = load("res://scripts/player.gd")
		if player_script:
			var player_instance = player_script.new()
			if player_instance:
				if "vines_cast_time" in player_instance:
					z = player_instance.vines_cast_time
				if "vines_cooldown_duration" in player_instance:
					cooldown = player_instance.vines_cooldown_duration
				player_instance.free()
	
	var tooltip_format = "[b]Entangling Vines[/b]\n\nVines sprout in all directions from the Druid, preventing enemies from moving for [color=yellow]%s[/color] seconds, and dealing [color=red]%s[/color] damage. The vines last for [color=green]%s[/color] seconds.\n\n[i]Cast Time: %s seconds\nCooldown: %s seconds[/i]"
	tooltip_text = tooltip_format % [str(w), str(x), str(y), str(z), str(cooldown)]
	
	print("AbilityVinesUI: Tooltip updated: ", tooltip_text)

func _make_custom_tooltip(for_text: String) -> Control:
	var label = RichTextLabel.new()
	label.bbcode_enabled = true
	label.text = for_text
	label.fit_content = true
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.custom_minimum_size = Vector2(300, 0)
	
	var container = PanelContainer.new()
	container.add_child(label)
	
	# Apply some basic styling to make it look like a tooltip
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.05, 0.05, 0.05, 0.95)
	style.border_width_left = 1
	style.border_width_top = 1
	style.border_width_right = 1
	style.border_width_bottom = 1
	style.border_color = Color(0.3, 0.3, 0.3)
	style.set_corner_radius_all(4)
	style.set_content_margin_all(8)
	container.add_theme_stylebox_override("panel", style)
	
	return container

func _on_level_up(new_level: int) -> void:
	if new_level >= 2:
		visible = true
	_update_tooltip()
