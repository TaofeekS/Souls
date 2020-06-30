extends Control

export(PackedScene) var intro_scn : PackedScene

export(NodePath) onready var name_edit = get_node(name_edit) as LineEdit if name_edit else null


func _get_name() -> String:
	if !name_edit : return ""
	
	var rslt : String = name_edit.text
	if rslt : return rslt
	
	var placeholder : String = name_edit.placeholder_text
	return placeholder
	


func _proceed() -> void:
	var intro_ins : Intro = intro_scn.instance()
	intro_ins.player_name = _get_name()
	
	get_tree().get_root().add_child(intro_ins)
	get_tree().set_current_scene(intro_ins)
	queue_free()
