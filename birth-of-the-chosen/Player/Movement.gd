extends Node2D

# DEBUG MODES
const GOD_SPEED_MULT: float = 5.0
@onready var hitbox: CollisionShape2D = $Player/Hitbox

const bullet_scene: PackedScene = preload("res://Player/bullet.tscn")
const swing_scene: PackedScene = preload("res://Player/sword_swing.tscn")
@onready var bullet_spawn_loc: Marker2D = $Player/BulletSpawnLoc
@onready var bullet_parent: Node2D = $BulletsOnScreen
@onready var swing_spawn_loc: Marker2D = $Player/SwingSpawnLoc
@onready var swing_parent: Node2D = $Player/SwingOnScreen
@onready var body: CharacterBody2D = $Player
const BULLET_SPEED: float = 300
@export var GRAVITY: int = 250
@export var MOVEMENT_SPEED: float = 150
@export var JUMP_VELOCITY: float = 200
@export var SPEED_CHANGE_RATE: float = 5
@export var JUMP_DASH_SPEED: float = 350
var can_jump_dash: bool = false
var jump_dash_object: Node2D = null
var jump_dashing: bool = false
var state_name: String = "Playing"
var facing_right: bool = true
var current_swing: Area2D = null

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Dash"):
		if can_jump_dash:
			jump_dashing = true
	if event.is_action_pressed("Shoot_Slash"):
		if bullet_parent.get_children().size() < 3:
			spawn_bullet()
		else:
			spawn_swing()

func _process(delta: float) -> void:
	var bullet_array: Array = bullet_parent.get_children()
	if bullet_array.size() > 0:
		for bullet: Area2D in bullet_array:
			if bullet.moving_right:
				bullet.global_position.x = move_toward(bullet.global_position.x, bullet.global_position.x + 100, BULLET_SPEED * delta)
			else:
				bullet.global_position.x = move_toward(bullet.global_position.x, bullet.global_position.x - 100, BULLET_SPEED * delta)
	match state_name:
		# REMOVE FROM HERE -----------------------------------------
		"GodMode":
			var dir: Vector2 = Input.get_vector("Move_Left", "Move_Right", "Move_Up (DEBUG)", "Move_Down (DEBUG)")
			body.velocity = dir * MOVEMENT_SPEED * GOD_SPEED_MULT
		# TO HERE ----------------------------------------------------
		"Playing":
			if Input.is_action_just_pressed("Jump") and body.is_on_floor():
				body.velocity.y -= JUMP_VELOCITY
			if not body.is_on_floor() and not jump_dashing:
				body.velocity.y += GRAVITY * delta
			if is_instance_valid(jump_dash_object) and jump_dashing:
				var dir: Vector2 = body.global_position.direction_to(jump_dash_object.global_position)
				body.velocity = dir * JUMP_DASH_SPEED
				jump_dashing = false
			else:
				var dir: float = Input.get_axis("Move_Left", "Move_Right")
				if dir < 0:
					facing_right = false
					bullet_spawn_loc.position.x = -16.0
					swing_spawn_loc.position.x = -21
				elif dir > 0:
					facing_right = true
					bullet_spawn_loc.position.x = 16.0
					swing_spawn_loc.position.x = 21
				body.velocity.x = move_toward(body.velocity.x, dir * MOVEMENT_SPEED, SPEED_CHANGE_RATE)
		"NotPlaying":
			if not body.is_on_floor():
				body.velocity.y += GRAVITY * delta
				jump_dashing = false
	body.move_and_slide()

func spawn_bullet() -> void:
	var new_bullet: Area2D = bullet_scene.instantiate()
	new_bullet.name = "Bullet"
	bullet_parent.add_child(new_bullet)
	new_bullet.global_position = bullet_spawn_loc.global_position
	new_bullet.visible = true
	new_bullet.moving_right = facing_right

func spawn_swing() -> void:
	if is_instance_valid(current_swing):
		return
	var new_swing: Area2D = swing_scene.instantiate()
	new_swing.name = "Swing"
	current_swing = new_swing
	swing_parent.add_child(new_swing)
	new_swing.position = swing_spawn_loc.position
	new_swing.visible = true
	await get_tree().create_timer(.3).timeout
	if is_instance_valid(new_swing):
		new_swing.queue_free()

# DEBUG STUFF (REMOVE LATER) ---------------------------------------
func _on_god_mode_pressed() -> void:
	state_name = "GodMode"
	DEBUG_set_player_vulnerable(false)

func _on_normal_mode_pressed() -> void:
	state_name = "Playing"
	DEBUG_set_player_vulnerable(true)

func DEBUG_set_player_vulnerable(vulnerable: bool) -> void:
	if vulnerable:
		hitbox.set_deferred("disabled", false)
	else:
		hitbox.set_deferred("disabled", true)
