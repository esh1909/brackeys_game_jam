class_name Cow extends CharacterBody2D

var is_being_beamed = false
@export var BEAM_SPEED = 1000
@export var GRAVITY = 100

@onready var _anim_state_machine: AnimationNodeStateMachinePlayback= $AnimationTree.get("parameters/playback")

func take_damage():
	print("Player hit cow")
	if !is_being_beamed:
		_anim_state_machine.travel("confused")

func release():
	is_being_beamed = false
	SignalBus.beam_ended.emit(self)

func _physics_process(delta: float) -> void:
	if is_being_beamed and _anim_state_machine.get_current_node() == "scared":
		velocity = Vector2.UP * BEAM_SPEED * delta
	else:
		#gravity
		velocity += Vector2.DOWN * GRAVITY * delta
	move_and_slide()
	
	
func die():
	SignalBus.died.emit(self)
	SignalBus.beam_ended.emit(self)
	queue_free()

func get_beamed():
	is_being_beamed = true
	SignalBus.beam_started.emit(self)
