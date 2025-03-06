extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		print("buttah collected")
		SignalBus.collected.emit(self)
		queue_free()
