extends Node2D

@onready var dash_indicator: MeshInstance2D = $Dash_Indicator
var player: CharacterBody2D = null

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		dash_indicator.visible = true
		player = body
		body.get_parent().can_jump_dash = true
		body.get_parent().jump_dash_object = self

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		dash_indicator.visible = false
		player = null
		body.get_parent().can_jump_dash = false
		body.get_parent().jump_dash_object = null

func _process(_delta: float) -> void:
	if is_instance_valid(player):
		dash_indicator.rotation = dash_indicator.global_position.direction_to(player.global_position).angle() + deg_to_rad(90)
