class_name State_Attack extends State

var attacking : bool = false
@export var attack_sound: AudioStream
@export_range(1, 20 , 0.5) var decelrate_speed : float = 5.0

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

@onready var walk: State = $"../Walk"
@onready var idle: State = $"../Idle"
@onready var hurt_box: HurtBox = $"../../HurtBox" 



#What happens when player enters this state
func Enter() -> void:
	player.UpdateAnimation("attack")
	animation_player.play("attack_side")
	animation_player.animation_finished.connect(EndAttack)
	$FX.play()
	attacking = true
	player.can_move = false
	player.velocity.x = 0
	
	await get_tree().create_timer(0.075).timeout
	
	hurt_box.monitoring = true
	pass
	
	
#what happens when player exits this state
func Exit() -> void:
	animation_player.animation_finished.disconnect(EndAttack)
	attacking = false
	player.can_move = true
	
	hurt_box.monitoring = false
	pass
	
	
#what happens during process update in this state
func Process(delta : float) -> State:
	player.velocity -= player.velocity * decelrate_speed * delta
	
	if attacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	return null
	

#what happens during _physics_process update in this state
func Physics(_delta : float) -> State:
	return null
	
	

#what happens with input events during this state
func HandleInput(_event : InputEvent) -> State:
	return null
	
	
func EndAttack( _newAnimName : String) -> void:
	attacking = false
