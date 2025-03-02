extends CharacterBody2D

@onready var animation_player = $AnimationPlayer


func _ready() -> void:
	animation_player.animation_finished.connect(animation_complete)
	animation_player.play("ground")

func animation_complete(anim):
	if anim == "ground":
		animation_player.play("idle")
	elif anim == "die":
		queue_free()

func die():
	animation_player.play("die")
