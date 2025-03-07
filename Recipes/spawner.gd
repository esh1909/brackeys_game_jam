extends  Node
@export var scn: PackedScene

signal spawned(obj: Node2D)

func spawn() -> Node:
	var obj = scn.instantiate()
	spawned.emit(obj)
	return obj
