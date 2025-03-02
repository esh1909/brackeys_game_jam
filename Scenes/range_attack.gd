class_name State_Range_Attack extends State

@onready var idle = $"../Idle"

var attacking : bool = false

@onready var projectile_scn = preload("res://Scenes/chakra.tscn")

@onready var cooldown_timer = $Cooldown

#What happens when player enters this state
func Enter() -> void:
	# fire projectile
	print("Firing projectile")
	var projectile = projectile_scn.instantiate()
	projectile.position = player.position
	get_tree().root.add_child(projectile)
	cooldown_timer.start()
	cooldown_timer.timeout.connect(timer_end)
	$FX.play()
	pass

func timer_end():
	print("timer ended")
	
#what happens when player exits this state
func Exit() -> void:
	pass
	
#what happens during process update in this state
func Process(delta : float) -> State:
	if not cooldown_timer.is_stopped():
		return null
	return idle
	
#what happens during _physics_process update in this state
func Physics(delta : float) -> State:
	return null
	
	
#what happens with input events during this state
func HandleInput(_event : InputEvent) -> State:
	return null
