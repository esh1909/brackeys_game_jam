class_name Player extends CharacterBody2D

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
const DIR_2 = [Vector2.RIGHT, Vector2.LEFT]
const jump_force = 200
const MAX_SPEED = 100
const GRAVITY = 10

var can_move = true

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
@onready var state_machine: PlayerStateMachine = $StateMachine

signal DirectionChanged(new_direction: Vector2)


# Called when the node enters the scene tree for the first time.
func _ready():
	state_machine.Initialize(self)
	
func take_damage():
	SignalBus.damaged.emit(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	#direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	#direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	if can_move:
		direction = Vector2(
			Input.get_axis("left", "right"), 
			0
		).normalized()
	else:
		direction = Vector2.ZERO
		velocity.x = 0
	
func _physics_process(_delta):
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y -= jump_force
	velocity += direction*100 + Vector2(0, GRAVITY)
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	#print(velocity)
	move_and_slide()

#for changing player direction based on movement	
func SetDirection() -> bool :
	if direction == Vector2.ZERO:
		return false
		
	var direction_id : int = int( round( (direction + cardinal_direction * 0.1).angle() / TAU * DIR_2.size() ) )
	var new_dir = DIR_2[direction_id]
		
	cardinal_direction = new_dir
	DirectionChanged.emit(new_dir)
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	
	var hurt_box_collider = $HurtBox/CollisionShape2D
	hurt_box_collider.position.x = -abs(hurt_box_collider.position.x) if cardinal_direction == Vector2.LEFT else abs(hurt_box_collider.position.x)
	
	return true

func UpdateAnimation(state: String) -> void:
	animation_player.play(state + "_" + AnimDirection())

	pass
	
	
#which direction player is facing
func AnimDirection() -> String:
	#if cardinal_direction == Vector2.DOWN:
		#return "down"
	#elif cardinal_direction == Vector2.UP:
		#return "up"
	#else:
		return "side"
