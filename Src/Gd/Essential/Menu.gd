extends Control

export(PackedScene) var setup_pck : PackedScene

func _new() -> void:
	var _dump := get_tree().change_scene_to(setup_pck)
	queue_free()

