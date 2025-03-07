extends Node
class_name DistributeBase
enum axes {x_axis, y_axis}

@export var parent: Node = null

var _previous_distribution_positions = []

func _get_new_position() -> Vector2:
	# Override and add your code here in child class
	return Vector2()

func _remove_node_position_from_memory(position: Vector2):
	var i = _previous_distribution_positions.find(position)
	if i != -1:
		_previous_distribution_positions.remove_at(i)

func distribute(node: Node2D):
	if parent == null:
		parent = get_parent()
	var new_position = _get_new_position()
	_previous_distribution_positions.append(new_position)
	node.position = new_position - parent.position
	node.tree_exited.connect(_remove_node_position_from_memory.bind(new_position))
	# Deffered Needed since first frame is still setting things up
	parent.add_child.call_deferred(node)
