class_name HitBox extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func TakeDamage(damage : int) -> void:
	print("TakeDamage " ,damage)
	if get_parent().has_method("take_damage"):
		get_parent().take_damage()
	elif get_parent().has_method("die"):
		get_parent().die()
	else:
		get_parent().queue_free()
		
