extends Node2D

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

@onready var player = $Player
@onready var _butter_level:float = starting_butter

var _cows_beamed_on_left: Array[Cow] = []
var _cows_beamed_on_right: Array[Cow] = []
var _butters_collected_so_far = 0

var positions: Array[int]

func _get_new_position() -> int:
	var new_pos = randi_range(SPAWN_MIN_X, SPAWN_MAX_X)
	while new_pos in positions:
		new_pos = randi_range(SPAWN_MIN_X, SPAWN_MAX_X)
	return new_pos

func restart_game():
	get_tree().reload_current_scene()
	
func _something_died(body: Node2D):
	print("died", body)
	if body is Cow:
		_cow_died()
	if body is Snake:
		_snake_died()
	if body is Ufo:
		_ufo_died()
		
func _damage_received(body):
	if body is Player:
		_player_damaged()
	
func _ready() -> void:
	SignalBus.died.connect(_something_died)
	SignalBus.beam_started.connect(_cow_beam_started)
	SignalBus.beam_ended.connect(_cow_beam_ended)
	SignalBus.collected.connect(_butter_collected)
	SignalBus.damaged.connect(_damage_received)
	
func _player_damaged():
	_butter_level -= 1
		
func _process(delta: float) -> void:
	if Input.is_action_pressed("restart"):
		restart_game()
	_butter_level -= delta*butter_loss_rate
	_butter_level = clamp(_butter_level, 0, MAX_BUTTER)
	score.size.x = lerp(score.size.x, _butter_level * BUTTER_TEXTURE_SIZE, 0.2)
	if _butter_level <= 0:
		restart_game()
		
	if len(_cows_beamed_on_left) > 0:
		$CanvasLayer/LeftDanger.visible = true
	else:
		$CanvasLayer/LeftDanger.visible = false
		
	if len(_cows_beamed_on_right) > 0:
		$CanvasLayer/RightDanger.visible = true
	else:
		$CanvasLayer/RightDanger.visible = false

func _cow_died():
	print("a cow died")
	_butter_level -= 2
	$"Cows and snakes/CowSpawner".spawn()

func _cow_beam_started(cow: Cow):
	print("Beam started")
	if cow.global_position.x > player.global_position.x:
		_cows_beamed_on_right.append(cow)
	if cow.global_position.x < player.global_position.x:
		_cows_beamed_on_left.append(cow)

func _cow_beam_ended(cow: Cow):
	print("Beam started")
	var i = _cows_beamed_on_right.find(cow)
	if i != -1:
		_cows_beamed_on_right.remove_at(i)
	else:
		i = _cows_beamed_on_left.find(cow)
		assert(i != -1)
		_cows_beamed_on_left.remove_at(i)

func _ufo_died():
	_butter_level += 2
	$Ufos/Spawner.spawn()

func _snake_died():
	$"Cows and snakes/SnakeSpawner".spawn()

func _butter_collected(node: Node):
	_butter_level += 1
