class_name HurtBox extends Area2D

@export var damage : int = 5


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(AreaEntered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func AreaEntered(a : Area2D) -> void:
	print("hurtbox ", get_parent(), get_parent().get_class())
	if a is HitBox:
		if self.get_parent() != a.get_parent():
			a.TakeDamage(damage)
		
	
		
