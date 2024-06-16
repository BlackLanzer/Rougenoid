extends RigidBody2D

enum BlockType { SIMPLE, WALL }
@export var block_type: BlockType = BlockType.SIMPLE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match block_type:
		BlockType.SIMPLE:
			$Sprite2D.set_texture(preload("res://assets/block_simple.png"))
			$Sprite2D.scale = Vector2(60,20)
			$Sprite2D.position = Vector2(30,10)
			$Sprite2D.modulate = Color('2e82c6')
		BlockType.WALL:
			$Sprite2D.set_texture(preload("res://assets/block_wall.png"))
			$Sprite2D.scale = Vector2(1,1)
			$Sprite2D.position = Vector2(30,10)




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func ball_hit(ball) -> void:
	match block_type:
		BlockType.SIMPLE:
			queue_free()
		BlockType.WALL:
			pass
