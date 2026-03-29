extends Node2D

@onready var timer = $Timer
@onready var explosion_area = $ExplosionArea
@onready var duration_bar = $DurationBar

var DEBUG = true
@export var DAMAGE = 9
@export var DURATION: float = 1.0

func _ready():
	process_mode = Node.PROCESS_MODE_PAUSABLE
	add_to_group("mushrooms")
	timer.wait_time = DURATION
	timer.start()
	
	duration_bar.max_value = DURATION
	duration_bar.value = DURATION

func _process(_delta):
	if timer.time_left > 0:
		duration_bar.value = timer.time_left

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
