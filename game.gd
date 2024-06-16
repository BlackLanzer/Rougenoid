extends Node2D

const PLAYER_VELOCITY = 400
const PLAYER_ACCELERATION = 400
const LEVELS = [
	"level_1",
	"level_2"
]

var _ball_res = preload ("res://ball.tscn")
var _balls = Array()
var _player
var _deadzone

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_physics_process(false)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		direction.x = PLAYER_VELOCITY
	if Input.is_action_pressed("ui_left"):
		direction.x = -PLAYER_VELOCITY
	if (Input.is_action_pressed("release_ball")):
		for ball in _balls:
			ball.state = BallState.MOVING
			ball.reparent(self)

	if direction != Vector2.ZERO:
		_player.move_and_collide(_player.velocity.move_toward(direction, PLAYER_ACCELERATION * delta))
	else:
		_player.move_and_collide(_player.velocity.move_toward(Vector2.ZERO, PLAYER_ACCELERATION * delta))

func _init_ball() -> void:
	var ball_node = _ball_res.instantiate()
	ball_node.position = Vector2(8, -16)
	ball_node.state = BallState.WITH_PLAYER
	_player.add_child(ball_node)
	_balls.append(ball_node)

func _on_ball_dead(ball) -> void:
	_balls.erase(ball)
	if (_balls.size() == 0):
		_init_ball()

func load_level(name: String) -> void:
	print("loading: ", name)
	var level = load("res://levels/" + name + ".tscn").instantiate()
	add_child(level)
	_player = get_tree().get_first_node_in_group("player")
	_deadzone = get_tree().get_first_node_in_group("dead_zone")
	_start_game()

func _start_game() -> void:
	_deadzone.body_entered.connect(_on_ball_dead)
	_init_ball()
	set_physics_process(true)
