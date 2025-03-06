extends Node2D

@export var amount_of_cows = 4
@export var amount_of_butter = 2
@export var amount_of_ufos = 3
@export var amount_of_snakes = 5
@export var butter_loss_rate = 0.1
@export var starting_butter = 3
@export var MAX_BUTTER = 10

@onready var score: TextureRect = $CanvasLayer/Score

const SPAWN_MIN_X = -20
const SPAWN_MAX_X = 20
const MIN_DISTANCE = 25
const GROUND_MIN_X = -900
const GROUND_MAX_X = 900
const BUTTER_TEXTURE_SIZE = 40

var _current_cows_in_game = 0
var _current_butter_in_game = 0
var _current_ufos_in_game = 0
var _current_snakes_in_game = 0
@onready var player = $Player
@onready var _butter_level:float = starting_butter

var _cows_beamed_on_left = 0
var _cows_beamed_on_right = 0
var _butters_collected_so_far = 0

var positions: Array[int]

func _get_new_position() -> int:
	var new_pos = randi_range(SPAWN_MIN_X, SPAWN_MAX_X)
	while new_pos in positions:
		new_pos = randi_range(SPAWN_MIN_X, SPAWN_MAX_X)
	return new_pos

func restart_game():
	get_tree().reload_current_scene()
	
func _ready() -> void:
	#var p = GROUND_MIN_X
	#while p <= GROUND_MAX_X:
		#
		#p += 1
	
	for i in range(amount_of_cows + amount_of_snakes + amount_of_ufos):
		positions.append(_get_new_position())
	
	for i in range(amount_of_cows):
		create_cow(positions.pop_back())

	for i in range(amount_of_ufos):
		create_ufo(positions.pop_back())
	
	for i in range(amount_of_snakes):
		create_snakes(positions.pop_back())
		
	$Player.damaged.connect(_player_damaged)

func _player_damaged():
	_butter_level -= 1
		
func _process(delta: float) -> void:
	if Input.is_action_pressed("restart"):
		restart_game()
	_butter_level -= delta*butter_loss_rate
	_butter_level = clamp(_butter_level, 0, MAX_BUTTER)
	score.size.x = _butter_level * BUTTER_TEXTURE_SIZE
	if _butter_level <= 0:
		restart_game()
		
	if _cows_beamed_on_left > 0:
		$CanvasLayer/LeftDanger.visible = true
	else:
		$CanvasLayer/LeftDanger.visible = false
		
	if _cows_beamed_on_right > 0:
		$CanvasLayer/RightDanger.visible = true
	else:
		$CanvasLayer/RightDanger.visible = false

func _cow_died():
	print("a cow died")
	_butter_level -= 2
	create_cow(randi_range(SPAWN_MIN_X, SPAWN_MAX_X))

func _cow_beam_started(cow: Cow):
	print("Beam started")
	if cow.global_position.x > player.global_position.x:
		_cows_beamed_on_right += 1
	if cow.global_position.x < player.global_position.x:
		_cows_beamed_on_left += 1

func _cow_beam_ended(cow: Cow):
	print("Beam started")
	if cow.global_position.x > player.global_position.x:
		_cows_beamed_on_right -= 1
	if cow.global_position.x < player.global_position.x:
		_cows_beamed_on_left -= 1

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
	new_cow.on_die.connect(_cow_died)
	new_cow.beam_started.connect(_cow_beam_started)
	new_cow.beam_ended.connect(_cow_beam_ended)


func _on_butter_spawn_timeout() -> void:
	for i in range(amount_of_butter):	
		generate_butter()
		
func _ufo_died():
	_butter_level += 2
	create_ufo(randi_range(SPAWN_MIN_X, SPAWN_MAX_X))
	
func _snake_died():
	create_snakes(randi_range(SPAWN_MIN_X, SPAWN_MAX_X))

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
	new_ufo.ufo_died.connect(_ufo_died)
	
func create_snakes(x_pos):
	const SNAKE = preload("res://Scenes/snake.tscn")
	var new_snake = SNAKE.instantiate()
	var snake_spawn_location = Vector2(x_pos*MIN_DISTANCE, 24)
	new_snake.position = snake_spawn_location
	self.add_child(new_snake)
	new_snake.snake_died.connect(_snake_died)
	
func _butter_collected():
	_butter_level += 1
	#score.text = "Butter: " + str(_butter_level)

func generate_butter():
	#create the butter
	const BUTTER =  preload("res://Scenes/butter.tscn")
	var new_butter = BUTTER.instantiate() 
	#give it a random spawn location for x and y axis
	var discrete_pos_x = randi_range(-10, 10)
	var discrete_pos_y = randi_range(-20, -70)
	var butter_spawn_location = Vector2(discrete_pos_x*MIN_DISTANCE, discrete_pos_y)
	new_butter.position = butter_spawn_location
	new_butter.collected.connect(_butter_collected)
	
	#make visible to user
	self.add_child(new_butter)
