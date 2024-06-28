extends CharacterBody2D

signal ball_dead

@export var start_direction = Vector2(1, -1)
@export var speed = 500.0
var direction: Vector2

var state = BallState.MOVING
var player: CharacterBody2D

func _ready() -> void:
	direction = start_direction.normalized()

func _process(delta: float) -> void:
	$DirectionLine.clear_points()
	$DirectionLine.add_point(Vector2.ZERO)
	$DirectionLine.add_point(velocity)
	$DirectionLine.global_rotation = 0

func _physics_process(delta: float) -> void:
	match state:
		BallState.WITH_PLAYER:
			position = player.position + Vector2(8, -16)
			velocity = direction * speed
		BallState.MOVING:
			var collision = move_and_collide(velocity * delta)
			
			if collision:
				var body = collision.get_collider()
				if body.is_in_group("player"):
					if get_position().y < body.get_global_position().y:
						direction = get_position() - Vector2(body.get_global_position().x, body.get_global_position().y + 8)
					else:
						direction = get_position() - Vector2(body.get_global_position().x, body.get_global_position().y - 8)
					velocity = direction.normalized() * speed
				elif body.is_in_group("blocks"):
					velocity = velocity.bounce(collision.get_normal())
					body.ball_hit(self)
				else:
					velocity = velocity.bounce(collision.get_normal())

func change_speed(new_speed: float) -> void:
	speed = new_speed
	velocity = speed * direction.normalized()
