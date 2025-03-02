class_name State_Jump extends State

@onready var walk: State = $"../Walk"
@onready var idle: State = $"../Idle"


#What happens when player enters this state
func Enter() -> void:
	player.UpdateAnimation("idle")
	player.velocity += Vector2.UP * 100
	pass
	
	
#what happens when player exits this state
func Exit() -> void:
	pass
	
	
#what happens during process update in this state
func Process(delta : float) -> State:
	if player.is_on_floor():
		return idle
	return null
	

#what happens during _physics_process update in this state
func Physics(delta : float) -> State:
	return null
	
	

#what happens with input events during this state
func HandleInput(_event : InputEvent) -> State:
	return null
