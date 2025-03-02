extends CharacterBody2D

var is_being_beamed = false
@export var BEAM_SPEED = 1000
@export var GRAVITY = 1000

func _ready() -> void:
	$AnimationPlayer.play("idle_cow")
	$AnimationPlayer.seek(randf_range(0, 0.3), true)
	$AnimationPlayer.speed_scale = randf_range(0.5,1.5)
	
	
func _physics_process(delta: float) -> void:
	if is_being_beamed:
		velocity = Vector2.UP * BEAM_SPEED * delta
	else:
		#gravity
		velocity = Vector2.DOWN * GRAVITY * delta
	move_and_slide()
	
func die():
	queue_free()

func get_beamed():
	$AnimationPlayer.play("scared")
	is_being_beamed = true

# Called when the node enters the scene tree for the first time.
