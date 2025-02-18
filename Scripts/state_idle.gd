class_name State_Idle extends State

@onready var walk: State = $"../Walk"
@onready var attack: State = $"../Attack"


#What happens when player enters this state
func Enter() -> void:
	player.UpdateAnimation("idle")
	pass
	
	
#what happens when player exits this state
func Exit() -> void:
	pass
	
	
#what happens during process update in this state
func Process(delta : float) -> State:
	if player.direction != Vector2.ZERO:
		return walk
	player.velocity = Vector2.ZERO
	return null
	

#what happens during _physics_process update in this state
func Physics(delta : float) -> State:
	return null
	
	

#what happens with input events during this state
func HandleInput(_event : InputEvent) -> State:
	if _event.is_action_pressed("attack"):
		return attack
	return null
