extends Node2D

@export var damage: int = 2
@export var snare_duration: float = 2.0
@export var radius: float = 80.0
@export var lifetime: float = 2.5

@onready var area_2d: Area2D = $Area2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D

func _ready() -> void:
	print("Vines spawned at ", global_position)
	# Update collision shape radius
	if collision_shape.shape is CircleShape2D:
		collision_shape.shape = collision_shape.shape.duplicate() # Make unique
		collision_shape.shape.radius = radius
	
	# Scale sprite to match radius (assuming sprite is 64x64)
	var texture_size = sprite.texture.get_size()
	var target_scale = (radius * 2.0) / max(texture_size.x, texture_size.y)
	sprite.scale = Vector2(target_scale, target_scale)
	
	# Detect enemies for a short window
	area_2d.body_entered.connect(_on_body_entered)
	
	# Immediate check
	await get_tree().physics_frame
	await get_tree().physics_frame
	
	var bodies = area_2d.get_overlapping_bodies()
	print("Vines checking bodies: ", bodies.size())
	for body in bodies:
		_apply_effect(body)
	
	# Visual effect: Fade out
	var tween = create_tween()
	tween.tween_interval(lifetime * 0.5)
	tween.tween_property(self, "modulate:a", 0.0, lifetime * 0.5)
	tween.tween_callback(queue_free)

func _on_body_entered(body: Node2D) -> void:
	_apply_effect(body)

var hit_bodies: Array[Node2D] = []

func _apply_effect(body: Node2D) -> void:
	if body.is_in_group("enemies") and not body in hit_bodies:
		hit_bodies.append(body)
		print("Vines hit enemy: ", body.name)
		if body.has_method("snare"):
			body.snare(snare_duration)
		if body.has_method("take_damage"):
			body.take_damage(damage)
