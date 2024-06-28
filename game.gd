extends Node2D

const PLAYER_VELOCITY = 500
const PLAYER_ACCELERATION = 400
const BALL_SPEED = 500
const LEVELS = [
	"level_1",
	"level_2",
	"level_3"
]

var _ball_res = preload ("res://entities/ball.tscn")
var _balls = Array()
var _deadzone
var _level_node
var _lives = 3
var _game_clock = 0
var _game_state = GameState.MENU
var _current_level = -1

signal game_over

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_physics_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _game_state == GameState.GAME:
		_game_clock += delta
		$UI/GameInfo/LblTimer.text = "%02d:%02d" % [floori(_game_clock / 60), int(_game_clock) % 60]
		$UI/GameInfo/LblLives.text = str(_lives)

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
		$Player.move_and_collide($Player.velocity.move_toward(direction, PLAYER_ACCELERATION * delta))
	else:
		$Player.move_and_collide($Player.velocity.move_toward(Vector2.ZERO, PLAYER_ACCELERATION * delta))

	if (_level_node.get_node("Level").get_child_count() == 0):
		_on_level_complete()

func _init_ball() -> void:
	var ball_node = _ball_res.instantiate()
	ball_node.state = BallState.WITH_PLAYER
	ball_node.speed = BALL_SPEED
	ball_node.player = $Player
	add_child(ball_node)
	_balls.append(ball_node)
	_lives -= 1

func _on_ball_dead(ball) -> void:
	_balls.erase(ball)
	if (_balls.size() == 0&&!_check_game_over()):
		_init_ball()

func load_level(level: int) -> void:
	if (_level_node != null):
		_level_node.free()
	print("loading: ", "res://levels/" + LEVELS[level] + ".tscn")
	_level_node = load("res://levels/" + LEVELS[level] + ".tscn").instantiate()
	_current_level = level
	add_child(_level_node)
	_deadzone = get_tree().get_first_node_in_group("dead_zone")
	_start_game()

func reset_game() -> void:
	_game_clock = 0
	_lives = 3
	_game_state = GameState.MENU
	set_physics_process(false)
	if (_level_node != null):
		_level_node.queue_free()

func _start_game() -> void:
	_deadzone.body_entered.connect(_on_ball_dead)
	_init_ball()
	set_physics_process(true)
	_game_state = GameState.GAME
	_setup_events()

func _on_level_complete() -> void:
	if (_current_level < LEVELS.size() - 1):
		_current_level += 1
		load_level(_current_level)
	else:
		_game_state = GameState.COMPLETED

func _check_game_over() -> bool:
	if (_lives == 0):
		_game_state = GameState.GAME_OVER
		game_over.emit()
		return true
	return false

func _setup_events() -> void:
	Events.connect("spawn_power_up", _spawn_power_up)
	Events.connect("activate_power_up", _activate_power_up)

func _spawn_power_up(pos: Vector2) -> void:
	var power_up = load("res://entities/power_up.tscn").instantiate()
	power_up.position = pos
	power_up.power_up_type = randi_range(0, 1)
	add_child(power_up)

func _activate_power_up(power_up) -> void:
	match power_up:
		PowerUpEnum.BIGGER_PLAYER:
			var tween = create_tween()
			var final_scale = Vector2($Player.scale.x + 0.2, $Player.scale.y)
			tween.tween_property($Player, "scale", final_scale, 1)
		PowerUpEnum.FASTER_BALL:
			for ball in _balls:
				ball.change_speed(ball.speed * 1.5)