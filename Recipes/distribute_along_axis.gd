extends Node
enum axes {x_axis, y_axis}

@export var fixed_axis: axes
@export var fixed_axis_value: float
@export var min_value: float
@export var max_value: float
@export var min_distance: float = 0.0
@export var parent: Node = null

var _previous_distribution_positions = []

func _ready():
	assert(min_value < max_value)
	assert((max_value - min_value) > min_distance)

func _get_new_position() -> Vector2:
	while true:
		var new_position = Vector2()
		if fixed_axis == axes.x_axis:
			new_position.x = fixed_axis_value
			new_position.y = randf_range(min_value, max_value)
		elif fixed_axis == axes.y_axis:
			new_position.x = randf_range(min_value, max_value)
			new_position.y = fixed_axis_value
		var _is_viable = true
		for pos in _previous_distribution_positions:
			if new_position.distance_to(pos) < min_distance:
				_is_viable = false
				break
		if _is_viable:
			_previous_distribution_positions.append(new_position)
			return new_position
	return Vector2()

func distribute(node: Node2D):
	if parent == null:
		parent = get_parent()
	var new_position = _get_new_position()
	node.position = new_position - parent.position
	print("distribute ", node.global_position)
	# Deffered Needed since first frame is still setting things up
	parent.add_child.call_deferred(node)
