extends CharacterBody2D

@export var speed = 300.0

var power_up_type = PowerUpEnum.BIGGER_PLAYER

func _ready() -> void:
	match power_up_type:
		PowerUpEnum.BIGGER_PLAYER:
			$Sprite2D.set_texture(preload ("res://assets/power-up_bigger-player.png"))
		PowerUpEnum.FASTER_BALL:
			$Sprite2D.set_texture(preload ("res://assets/power-up_faster-ball.png"))

func _physics_process(delta: float) -> void:
	velocity.x = 0
	velocity.y = speed
	var collision = move_and_collide(velocity * delta)

	if collision:
		var body = collision.get_collider()
		if body.is_in_group("player"):
			Events.activate_power_up.emit(power_up_type)
			queue_free()
