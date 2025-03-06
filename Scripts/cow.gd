class_name Cow extends CharacterBody2D

var is_being_beamed = false
@export var BEAM_SPEED = 1000
@export var GRAVITY = 100

@onready var _anim_state_machine: AnimationNodeStateMachinePlayback= $AnimationTree.get("parameters/playback")

#func _play_idle():
	#$AnimationPlayer.play("idle_cow")
	#$AnimationPlayer.seek(randf_range(0, 0.3), true)
	#$AnimationPlayer.speed_scale = randf_range(0.7,2)

	
func release():
	is_being_beamed = false
	SignalBus.beam_ended.emit(self)

func _physics_process(delta: float) -> void:
	if is_being_beamed and _anim_state_machine.get_current_node() == "scared":
		velocity = Vector2.UP * BEAM_SPEED * delta
	else:
		#gravity
		velocity += Vector2.DOWN * GRAVITY * delta
		if is_on_floor() and not _anim_state_machine.get_current_node() == "idle_cow":
			pass
			#_play_idle()
	move_and_slide()
	
	
func die():
	SignalBus.died.emit(self)
	SignalBus.beam_ended.emit(self)
	queue_free()

func get_beamed():
	#$AnimationPlayer.play("scared")
	is_being_beamed = true
	SignalBus.beam_started.emit(self)

# Called when the node enters the scene tree for the first time.
