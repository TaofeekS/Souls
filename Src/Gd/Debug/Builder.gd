tool

extends Node

func _ready():
	print("readyy")
	var test = $Player
	test.set("hp", 88)
	test.property_list_changed_notify()
