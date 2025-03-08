extends Node

@export var max_count: int = 0

signal counted
func _count():
	for i in range(max_count):
		print("counting " + str(i))
		counted.emit()

func count():
	_count.call_deferred()
	
