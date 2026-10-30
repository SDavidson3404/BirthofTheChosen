extends Area2D

const BULLET_LIFE: float = 1.5
var current_timer: float = 0.0
var moving_right: bool

func _process(delta: float) -> void:
	current_timer += delta
	if current_timer >= BULLET_LIFE:
		queue_free()
