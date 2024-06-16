extends CanvasLayer

var game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game = $game
	for lvl in game.LEVELS:
		$start_menu/LevelSelector.add_item(lvl)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_btn_start_pressed() -> void:
	var level = "level_" + str($start_menu/LevelSelector.selected + 1)
	$start_menu.visible = false
	game.load_level(level)
