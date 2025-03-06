extends Sprite2D
class_name Ufo

const UFO_EDGE_POSITION = 200
var ufo_starting_pos: float 
var ufo_end_pos: float 
@export var UFO_SPEED = 20

var ray: RayCast2D
var my_cow: Node
const FINAL_BEAM_SCALE_Y = 4.1
const BEAM_SPEED = 5
var alpha: float = 0.0

@onready var beam_sprite = $Beam

func _ready() -> void:
	ufo_starting_pos = self.position.x
	ufo_end_pos = ufo_starting_pos + UFO_EDGE_POSITION
	ray = $CowRay
	my_cow = null
	
func die():
	if my_cow and my_cow != null:
		my_cow.release()
	SignalBus.died.emit(self)
	queue_free()

func _process(delta: float):
	if ray.is_colliding():  # If raycast found a cow
		var cow = ray.get_collider()
		if cow == null:
			return
		#print("Pick the cow up", ray.get_collider())
		if cow is Cow and not cow.is_being_beamed:   # If the cow is not already being beamed by a UFO
			cow.get_beamed()
			my_cow = cow   # I own this cow now
		if cow == my_cow:  # If my_cow is still under my beam
			beam_sprite.scale.y = FINAL_BEAM_SCALE_Y
			return   # Do not move
	beam_sprite.scale.y = 0
	if ufo_starting_pos < ufo_end_pos:
		self.position.x += UFO_SPEED * delta
		if self.position.x >= ufo_end_pos:
			var temp = ufo_end_pos
			ufo_end_pos = ufo_starting_pos
			ufo_starting_pos = temp
				
	if ufo_starting_pos > ufo_end_pos:
		self.position.x -= UFO_SPEED *delta
		if self.position.x < ufo_end_pos:
			var temp = ufo_starting_pos
			ufo_starting_pos = ufo_end_pos
			ufo_end_pos = temp

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == my_cow:
		my_cow.die()
