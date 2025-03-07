extends DistributeBase

@export var fixed_axis: axes
@export var fixed_axis_value: float
@export var min_value: float
@export var max_value: float
@export var min_distance: float = 0.0

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
			return new_position
	return Vector2()
