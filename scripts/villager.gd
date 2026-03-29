extends CharacterBody2D

@export var speed: float = 80.0
@export var acceleration: float = 50.0
@export var max_health: int = 69
@export var health: int = max_health
@export var health_bar_scene: PackedScene
@export var attack_damage: int = 45
@export var attack_cooldown: float = 1.0
@export var experience: int = 8

var player = null
var DEBUG = true
var health_bar
var last_attack_time: float = -100.0

var is_snared: bool = false
var snare_timer: float = 0.0

func _ready():
	process_mode = Node.PROCESS_MODE_PAUSABLE
	player = get_tree().get_first_node_in_group("player")
	if player:
		print("Villager found player:", player)
	else:
		print("Villager could not find player!")
	
	health_bar = health_bar_scene.instantiate()
	add_child(health_bar)
	health_bar.set_max_health(max_health)
	health_bar.set_health(health)

func _physics_process(delta):
	if is_snared:
		snare_timer -= delta
		if snare_timer <= 0:
			is_snared = false
		return # Stop moving while snared

	if player == null:
		return

	var direction = (player.global_position - global_position).normalized()

	var target_velocity = direction * speed

	# Smoothly interpolate current velocity toward target
	velocity = velocity.lerp(target_velocity, acceleration * delta)

	# Move the character with collision
	move_and_slide()  # velocity is read from the CharacterBody2D.velocity property

	# Attack logic
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider.is_in_group("player"):
			_try_attack(collider)

func _try_attack(target):
	var current_time = Time.get_ticks_msec() / 1000.0
	if current_time - last_attack_time >= attack_cooldown:
		if target.has_method("take_damage"):
			print("Villager attacking player!")
			target.take_damage(attack_damage)
			last_attack_time = current_time
			if DEBUG:
				print("Villager attacked player for ", attack_damage, " damage!")

func take_damage(amount):
	health -= amount
	health_bar.set_health(health)
	
	if DEBUG:
		print("Villager took damage:", amount)

	if health <= 0:
		die()

func die():
	print("Villager died 💀")
	if GameManager:
		GameManager.add_kill()
		GameManager.add_experience(experience)
	queue_free()

func snare(duration: float):
	is_snared = true
	snare_timer = duration
