extends Area2D

	


func _on_butter_leave_timeout() -> void:
	self.queue_free()
	
	



func _on_body_entered(body: Node2D) -> void:
	print("buttah collected")
	queue_free()
