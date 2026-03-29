extends CharacterBody2D

signal died

@export var villager_scene: PackedScene
@export var spawn_min_radius: float = 150.0
@export var spawn_max_radius: float = 300.0
@export var mushroom_scene: PackedScene
@export var speed: float = 200.0
@export var acceleration: float = 15.0
@export var max_health: int = 100
@export var health: int = max_health
@export var health_bar_scene: PackedScene
@export var vines_scene: PackedScene

var is_casting: bool = false
var health_bar
var next_spawn_count: int = 5
var is_spawning_wave: bool = false

@onready var cast_bar: ProgressBar = $CastProgressBar

func _ready():
	process_mode = Node.PROCESS_MODE_PAUSABLE
	velocity = Vector2.ZERO
	# Initial spawn is handled by the check in _physics_process
	
	if health_bar_scene:
		health_bar = health_bar_scene.instantiate()
		add_child(health_bar)
		health_bar.set_max_health(max_health)
		health_bar.set_health(health)

func take_damage(amount: int):
	health -= amount
	print("Player took ", amount, " damage! Health is now: ", health)
	
	# Visual feedback: flash red
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.RED, 0.1)
	tween.tween_property(self, "modulate", Color.WHITE, 0.1)
	
	if health_bar:
		health_bar.set_health(health)
	
	if health <= 0:
		die()

func die():
	print("Player died!")
	died.emit()

func _physics_process(delta):
	# Check for respawn first
	check_for_respawn()

	var direction = Vector2.ZERO

	if not is_casting:
		if Input.is_action_pressed("move_up"):
			direction.y -= 1
		if Input.is_action_pressed("move_down"):
			direction.y += 1
		if Input.is_action_pressed("move_left"):
			direction.x -= 1
		if Input.is_action_pressed("move_right"):
			direction.x += 1

	direction = direction.normalized()

	var target_velocity = direction * speed

	# Smoothly interpolate current velocity toward target
	velocity = velocity.lerp(target_velocity, acceleration * delta)

	# Move the character with collision
	move_and_slide()  # velocity is read from the CharacterBody2D.velocity property

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("cast_ability"):
		spawn_mushroom()
	elif event.is_action_pressed("cast_ability_2"):
		cast_entangling_vines()

func check_for_respawn():
	if is_spawning_wave:
		return
	
	# Use a small delay or check group size
	var enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.is_empty():
		spawn_wave()

func spawn_wave():
	is_spawning_wave = true
	print("Spawning wave of ", next_spawn_count, " villagers")
	for i in range(next_spawn_count):
		spawn_villager()
	next_spawn_count += 1
	is_spawning_wave = false

func spawn_mushroom():
	if is_casting:
		return
		
	var cast_time = 0.33
	is_casting = true
	cast_bar.value = 100.0
	cast_bar.visible = true
	
	var tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_STOP)
	tween.tween_property(cast_bar, "value", 0.0, cast_time)
	
	await tween.finished
	
	cast_bar.visible = false
	
	var mushroom = mushroom_scene.instantiate()

	# Get mouse position in world space
	var mouse_pos = get_global_mouse_position()

	mushroom.global_position = mouse_pos

	get_parent().add_child(mushroom)
	
	is_casting = false

func cast_entangling_vines():
	if is_casting:
		return
	
	var cast_time = 0.5
	is_casting = true
	cast_bar.value = 100.0
	cast_bar.visible = true
	
	var tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_STOP)
	tween.tween_property(cast_bar, "value", 0.0, cast_time)
	
	await tween.finished
	
	cast_bar.visible = false
	
	if vines_scene:
		var vines = vines_scene.instantiate()
		vines.global_position = global_position
		get_parent().add_child(vines)
	
	is_casting = false

func spawn_villager():
	print("Spawning villager...")
	var villager = villager_scene.instantiate()

	var angle = randf() * TAU  # random direction
	var distance = randf_range(spawn_min_radius, spawn_max_radius)

	var offset = Vector2(cos(angle), sin(angle)) * distance
	var spawn_position = global_position + offset

	villager.global_position = spawn_position

	get_parent().add_child(villager)
