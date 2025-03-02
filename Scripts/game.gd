extends Node2D

@export var amount_of_cows = 3
@export var amount_of_butter = 3
@export var amount_of_ufos = 2
@export var amount_of_snakes = 3

const SPAWN_MIN_X = -10
const SPAWN_MAX_X = 10
const MIN_DISTANCE = 25

var positions: Array[int]

func _get_new_position() -> int:
	var new_pos = randi_range(SPAWN_MIN_X, SPAWN_MAX_X)
	while new_pos in positions:
		new_pos = randi_range(SPAWN_MIN_X, SPAWN_MAX_X)
	return new_pos

func _ready() -> void:
	for i in range(amount_of_cows + amount_of_snakes + amount_of_ufos):
		positions.append(_get_new_position())
	
	for i in range(amount_of_cows):
		create_cow(positions.pop_back())

	for i in range(amount_of_ufos):
		create_ufo(positions.pop_back())
	
	for i in range(amount_of_snakes):
		create_snakes(positions.pop_back())

func create_cow(x_pos):
	#create the cow
	const COW = preload("res://Scenes/cow.tscn")   
	var new_cow = COW.instantiate() 
	#give it a random spawn location for x and y axis
	var cow_spawn_location = Vector2(x_pos*MIN_DISTANCE, 0)
	print(cow_spawn_location)
	#assign spawn position to cow instance
	new_cow.position = cow_spawn_location
	#make cow visible to user
	self.add_child(new_cow)


func _on_butter_spawn_timeout() -> void:
	for i in range(amount_of_butter):	
		generate_butter()
		
func create_ufo(x_pos):
	#create the ufo
	const UFO = preload("res://Scenes/ufo.tscn")
	var new_ufo = UFO.instantiate() 
	#give it a random spawn location for x and y axis
	var ufo_spawn_location = Vector2(x_pos*MIN_DISTANCE, -100)
	
	#assign spawn position to ufo instance
	new_ufo.position = ufo_spawn_location
	#make visible to user
	self.add_child(new_ufo)
	
func create_snakes(x_pos):
	const SNAKE = preload("res://Scenes/snake.tscn")
	var new_snake = SNAKE.instantiate()
	var snake_spawn_location = Vector2(x_pos*MIN_DISTANCE, 24)
	new_snake.position = snake_spawn_location
	self.add_child(new_snake)
	
func generate_butter():
	#create the butter
	const BUTTER =  preload("res://Scenes/butter.tscn")
	var new_butter = BUTTER.instantiate() 
	#give it a random spawn location for x and y axis
	var discrete_pos = randi_range(-10, 10)
	var butter_spawn_location = Vector2(discrete_pos*MIN_DISTANCE, 0)
	new_butter.position = butter_spawn_location
	
	#make visible to user
	self.add_child(new_butter)
