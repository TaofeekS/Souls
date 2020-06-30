extends Control

export(NodePath) onready var msg_label = get_node(msg_label) as Label if msg_label else null
export(String, MULTILINE) var msg_txt : String

export(NodePath) onready var reset_btn = get_node(reset_btn) as Button if reset_btn else null
export(String) var reset_txt : String


func _ready() -> void:
	msg_label.text = msg_txt
	reset_btn.text = reset_txt


func _try_again() -> void:
	var _dump := get_tree().reload_current_scene()
