extends Node
class_name DistributeBase
enum axes {x_axis, y_axis}

@export var parent: Node = null

var _previous_distribution_positions = []

func _get_new_position() -> Vector2:
	# Override and add your code here in child class
	return Vector2()

func distribute(node: Node2D):
	if parent == null:
		parent = get_parent()
	var new_position = _get_new_position()
	_previous_distribution_positions.append(new_position)
	node.position = new_position - parent.position
	# Deffered Needed since first frame is still setting things up
	parent.add_child.call_deferred(node)
