extends RigidBody2D

# TODO rimuovere POWER_UP
enum BlockType {SIMPLE, WALL, POWER_UP}
@export var block_type: BlockType = BlockType.SIMPLE
@export var has_power_up: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match block_type:
		BlockType.SIMPLE:
			$Sprite2D.set_texture(preload ("res://assets/block_simple.png"))
			$Sprite2D.scale = Vector2(60, 20)
			$Sprite2D.position = Vector2(30, 10)
			$Sprite2D.modulate = Color('2e82c6')
			if (!has_power_up&&randf() < 0.3):
				has_power_up = true
				block_type = BlockType.POWER_UP
		BlockType.WALL:
			$Sprite2D.set_texture(preload ("res://assets/block_wall.png"))
			$Sprite2D.scale = Vector2(1, 1)
			$Sprite2D.position = Vector2(30, 10)
	
	# TODO rimuovere POWER_UP e usare has_power_up
	if (block_type == BlockType.POWER_UP):
		$Sprite2D.set_texture(preload ("res://assets/block_simple.png"))
		$Sprite2D.scale = Vector2(60, 20)
		$Sprite2D.position = Vector2(30, 10)
		$Sprite2D.modulate = Color('d62b67')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func ball_hit(ball) -> void:
	match block_type:
		BlockType.SIMPLE:
			queue_free()
		BlockType.WALL:
			pass
		BlockType.POWER_UP:
			Events.spawn_power_up.emit(position)
			queue_free()
