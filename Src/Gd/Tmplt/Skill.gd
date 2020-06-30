class_name Skill, "res://Src/Asset/Png/Skill/Armor.png"
extends Node2D

"""
	To keep game elements decoupled from one another, this node will only be
responsible for visual and hit timing -> striked
"""

signal striked


func _strike() -> void:
	emit_signal("striked")


func _anim_finished(_anim_name):
	queue_free()
