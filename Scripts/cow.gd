extends CharacterBody2D

var is_being_beamed = false
@export var BEAM_SPEED = 1000
@export var GRAVITY = 100

func _play_idle():
	$AnimationPlayer.play("idle_cow")
	$AnimationPlayer.seek(randf_range(0, 0.3), true)
	$AnimationPlayer.speed_scale = randf_range(0.7,2)

func _ready() -> void:
	_play_idle()
	
func release():
	is_being_beamed = false

func _physics_process(delta: float) -> void:
	if is_being_beamed:
		velocity = Vector2.UP * BEAM_SPEED * delta
	else:
		#gravity
		velocity += Vector2.DOWN * GRAVITY * delta
		if is_on_floor() and not $AnimationPlayer.current_animation == "idle_cow":
			_play_idle()
	move_and_slide()
	
func die():
	queue_free()

func get_beamed():
	$AnimationPlayer.play("scared")
	is_being_beamed = true

# Called when the node enters the scene tree for the first time.
