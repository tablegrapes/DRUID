extends CharacterBody2D

@export var villager_scene: PackedScene
@export var spawn_min_radius: float = 150.0
@export var spawn_max_radius: float = 300.0
@export var mushroom_scene: PackedScene
@export var speed: float = 200.0
@export var acceleration: float = 10.0

func _ready():
	velocity = Vector2.ZERO 

func _physics_process(delta):
	var direction = Vector2.ZERO

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

	velocity = velocity.lerp(target_velocity, acceleration * delta)

	move_and_slide()
	
func _input(event):
	if event.is_action_pressed("cast_ability"):
		spawn_mushroom()
		
func spawn_mushroom():
	var mushroom = mushroom_scene.instantiate()

	# Get mouse position in world space
	var mouse_pos = get_global_mouse_position()

	mushroom.global_position = mouse_pos

	get_parent().add_child(mushroom)
