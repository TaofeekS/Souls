class_name Intro

extends Control

export(String) var player_name : String
export(String) var someone_name : String

# Text per second
export(float) var txt_ps : float

export(PackedScene) var main_pck : PackedScene
export(NodePath) onready var author_label = get_node(author_label) as Label if author_label else null
export(NodePath) onready var motto_label = get_node(motto_label) as Label if motto_label else null
export(NodePath) onready var txt_timer = get_node(txt_timer) as Timer if txt_timer else null

# Exporting dictionary is super tedious and risky
# as changing index, modifying key name is a nightmare
onready var dialogue := {
	0 : {someone_name : "You've been pondering for a while now, is there something fretting you my Dear?"},
	1 : {player_name : "i guess so..."},
	2 : {player_name : "so ummmn, where's my grandpa?"},
	3 : {someone_name : "Your Grandpa went to, well hmm, You're probably too young to comprehend"},
	4 : {player_name : "pls trust me, i can handle it"},
	5 : {someone_name : "Very well then, hmmmm, how do I delineate this"},
	6 : {someone_name : "Well when your Father was around Your age, Your Grandpa went to the dungeon to buy some milk"},
	7 : {player_name : "and??, did he get some?"},
	8 : {someone_name : "He will, He promised"},
	9 : {someone_name : "That one day He will bring home some, and I'm still waiting :)"},
	10 : {player_name : "grandpa must be very wise. can you tell me more about grandfather? What does he look like"},
}



func _ready() -> void:
	_next()


func _input(event):
	var is_next = event.is_action_pressed("tap")
	if is_next : _next()


# Updates the ui to the next dialogue
func _next() -> void:
	_finish()
	if !dialogue : return
	
	var next_key : int = dialogue.keys().front()
	var next_dialogue : Dictionary = dialogue[next_key]
	var author_txt : String = next_dialogue.keys().front()
	var motto_txt : String = next_dialogue[author_txt]
	
	_safe_set(author_label, "text", author_txt)
	_safe_set(motto_label, "text", motto_txt)
	
	var _dump := dialogue.erase(next_key)


# Animate text, not yet implemented
func _anim_txt() -> void:
	txt_timer.start(txt_ps)


func _safe_set(ref : Node, property : String, val) -> void:
	if !ref : return
	ref.set(property, val)


func _finish() -> void:
	if dialogue : return
	
	var main_ins : Main = main_pck.instance()
	main_ins.player_name = player_name
	get_tree().get_root().add_child(main_ins)
	get_tree().set_current_scene(main_ins)
	queue_free()
