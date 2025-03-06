class_name State_Walk extends State

@export var move_speed : float = 100.0
@onready var idle: State = $"../Idle"
@onready var attack: State = $"../Attack"
@onready var range_attack: State = $"../Range_Attack"
@onready var jump: State = $"../Jump"

	

#What happens when player enters this state
func Enter() -> void:
	player.UpdateAnimation("walk")
	pass
	
	
#what happens when player exits this state
func Exit() -> void:
	pass
	
	
#what happens during process update in this state
func Process(_delta : float) -> State:
	if not player.is_on_floor():
		return jump
	if player.direction == Vector2.ZERO:
		return idle
		
	if player.SetDirection():
		player.UpdateAnimation("walk")
	return null
	

#what happens during _physics_process update in this state
func Physics(_delta : float) -> State:
	return null

#what happens with input events during this state
func HandleInput(_event : InputEvent) -> State:
	if _event.is_action_pressed("attack"):
		return attack
	elif _event.is_action_pressed("range_attack"):
		return range_attack
	return null
