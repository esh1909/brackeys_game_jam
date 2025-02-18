class_name State extends Node

#Stores a reference to player that this state belongs to
static var player : Player


func _ready() -> void:
	pass # Replace with function body.
	

#What happens when player enters this state
func Enter() -> void:
	pass
	
	
#what happens when player exits this state
func Exit() -> void:
	pass
	
	
#what happens during process update in this state
func Process(delta : float) -> State:
	return null
	

#what happens during _physics_process update in this state
func Physics(delta : float) -> State:
	return null
	
	

#what happens with input events during this state
func HandleInput(_event : InputEvent) -> State:
	return null
