extends Node2D

@onready var pause_menu: CanvasLayer = $PauseMenu
@onready var label: Label = $PauseMenu/CenterContainer/Label
@onready var player: CharacterBody2D = $Player/CharacterBody2D

@onready var ability_vines_ui: Control = $HUD/AbilityVinesUI

var game_started: bool = false
var player_dead: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	# Ensure the player and its children pause when the game is paused
	$Player.process_mode = Node.PROCESS_MODE_PAUSABLE
	
	label.text = "PRESS ESC TO BEGIN"
	pause_menu.visible = true
	get_tree().paused = true
	
	player.died.connect(_on_player_died)
	player.level_up.connect(ability_vines_ui._on_level_up)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if not game_started:
			start_game()
		elif player_dead:
			GameManager.reset_kills()
			get_tree().paused = false
			get_tree().reload_current_scene()
		else:
			toggle_pause()

func start_game() -> void:
	game_started = true
	get_tree().paused = false
	pause_menu.visible = false
	label.text = "PAUSED" # Reset for future pauses

func toggle_pause() -> void:
	get_tree().paused = not get_tree().paused
	pause_menu.visible = get_tree().paused
	if get_tree().paused:
		label.text = "PAUSED"

func _on_player_died() -> void:
	player_dead = true
	label.text = "YOU DIED"
	pause_menu.visible = true
	get_tree().paused = true
