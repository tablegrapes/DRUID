extends CharacterBody2D

@onready var health_bar: ProgressBar = $HealthBar

var health: int = 100
var speed: float = 200.0

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	move_and_slide()

func take_damage(amount: int) -> void:
	health -= amount
	print("Player health: ", health)
	if health_bar:
		health_bar.value = health
	if health <= 0:
		die()

func die() -> void:
	print("Player died!")
	get_tree().reload_current_scene()
