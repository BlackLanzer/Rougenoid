extends CharacterBody2D

signal ball_dead

@export var start_direction = Vector2(1, -1)
@export var speed = 500.0
var direction: Vector2

var state = BallState.MOVING

func _ready() -> void:
	direction = start_direction.normalized()
	velocity = direction * speed

func _process(delta: float) -> void:
	$DirectionLine.clear_points()
	$DirectionLine.add_point(Vector2.ZERO)
	$DirectionLine.add_point(velocity)
	$DirectionLine.global_rotation = 0

func _physics_process(delta: float) -> void:
	if state == BallState.MOVING:
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
