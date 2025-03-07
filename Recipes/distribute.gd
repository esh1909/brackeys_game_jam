extends DistributeBase

@export var min_x_value: float
@export var max_x_value: float
@export var min_y_value: float
@export var max_y_value: float
@export var min_distance: float = 0.0


func _ready():
	assert(min_x_value < max_x_value)
	assert(min_y_value < max_y_value)

func _get_new_position() -> Vector2:
	while true:
		var new_position = Vector2()
		new_position.x = randf_range(min_x_value, max_x_value)
		new_position.y = randf_range(min_y_value, max_y_value)
		var _is_viable = true
		for pos in _previous_distribution_positions:
			if new_position.distance_to(pos) < min_distance:
				_is_viable = false
				break
		if _is_viable:
			return new_position
	return Vector2()
