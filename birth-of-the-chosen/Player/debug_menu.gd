extends Control

const VERSION_SETTING: String = "application/config/version"

@onready var fps: Label = $MarginContainer/VBoxContainer/FPS
@onready var version: Label = $MarginContainer/VBoxContainer/Version
@onready var dimension: Label = $MarginContainer/VBoxContainer/Dimension

func _ready() -> void:
	_add_version_to_info_label()

func _process(_delta: float) -> void:
	fps.text = ("FPS: " + str(Engine.get_frames_per_second()))
	dimension.text = ("Dimension: " + VoidSwitch.current_dim)

func _add_version_to_info_label() -> void:
	var version_string: String = ProjectSettings.get_setting(VERSION_SETTING)
	version.text += version_string
