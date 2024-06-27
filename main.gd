extends CanvasLayer

var _game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_game = $game
	_game.visible = false
	for i in _game.LEVELS.size():
		$start_menu/LevelSelector.add_item(_game.LEVELS[i], i)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_btn_start_pressed() -> void:
	var level = $start_menu/LevelSelector.get_selected_id()
	$start_menu.visible = false
	_game.visible = true
	_game.reset_game()
	_game.load_level(level)

func _on_game_over() -> void:
	$start_menu.visible = true
	_game.visible = false
	_game.reset_game()
	pass # Replace with function body.
