extends Node2D

@onready var timer = $Timer
@onready var explosion_area = $ExplosionArea
@onready var duration_bar = $DurationBar
@onready var sprite = $Sprite2D
@onready var collision_shape = $ExplosionArea/CollisionShape2D

var DEBUG = true
@export var DAMAGE = 9
@export var DURATION: float = 1.0

var target_scale: Vector2
var initial_scale: Vector2

func _ready():
	process_mode = Node.PROCESS_MODE_PAUSABLE
	add_to_group("mushrooms")
	
	timer.wait_time = DURATION
	timer.start()
	
	duration_bar.max_value = DURATION
	duration_bar.value = DURATION
	
	# Calculate target scale based on explosion area radius
	var radius = collision_shape.shape.radius
	var diameter = radius * 2.0
	var tex_size = sprite.texture.get_size()
	
	target_scale = Vector2(diameter / tex_size.x, diameter / tex_size.y)
	initial_scale = target_scale * 0.125
	sprite.scale = initial_scale

func _process(_delta):
	if timer.is_stopped():
		return
		
	duration_bar.value = timer.time_left
	
	var progress = (DURATION - timer.time_left) / DURATION
	sprite.scale = initial_scale.lerp(target_scale, progress)

func _on_explosion_timer_timeout():
	explode()

func explode():
	print("KABLAMO!!!")

	explosion_area.monitoring = true

	await get_tree().physics_frame

	if DEBUG:
		print("Checking overlaps...")
	var bodies = explosion_area.get_overlapping_bodies()
	if DEBUG:
		print("Bodies found:", bodies)

	for body in bodies:
		if body.is_in_group("enemies"):
			if body.has_method("take_damage"):
				body.take_damage(DAMAGE)

	queue_free()
