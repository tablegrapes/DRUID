extends Node2D

@export var max_health: int
var current_health: int

@onready var bar = $Bar

func _ready():
	process_mode = Node.PROCESS_MODE_INHERIT
	current_health = max_health
	bar.max_value = max_health
	bar.value = current_health
	bar.position = Vector2(-bar.size.x / 2, -40)

func set_health(value: int):
	current_health = clamp(value, 0, max_health)
	bar.value = current_health

func set_max_health(value: int):
	max_health = value
	bar.max_value = max_health
	
