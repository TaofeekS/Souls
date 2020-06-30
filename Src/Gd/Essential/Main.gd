class_name Main

extends Control

# Will be overwritten by intro, if not isolated
export(String) var player_name : String

signal player_named(name_txt)


func _ready() -> void:
	emit_signal("player_named", player_name)

