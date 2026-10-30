extends Node2D

var current_dim: String = "Physical"
var physical_parent: Node2D
var void_parent: Node2D

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Switch"):
		if current_dim == "Physical":
			switch_dims(true, false)
			current_dim = "Void"
		else:
			switch_dims(false, true)
			current_dim = "Physical"

func _ready() -> void:
	get_dim_parent_nodes()
	switch_dims(false, true)

func get_dim_parent_nodes() -> void:
	for child in get_tree().current_scene.get_children():
		if child.name == "Physical":
			physical_parent = child
		elif child.name == "Void":
			void_parent = child

func switch_dims(is_void: bool, is_phys: bool) -> void:
	for child in physical_parent.find_children("", "CollisionShape2D", true, false):
		if child is CollisionShape2D:
			child.disabled = is_void
	for child in void_parent.find_children("", "CollisionShape2D", true, false):
		if child is CollisionShape2D:
			child.disabled = is_phys
	void_parent.visible = is_void
	physical_parent.visible = is_phys
