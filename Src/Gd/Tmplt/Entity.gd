class_name Entity, "res://Src/Asset/Png/Monster/minion_dolphin1.png"

extends MarginContainer

export(float) var hp : float
export(float) var atk : float
export(float) var def : float
export(float) var spd : float

# How much does each def reduce a damage
# higly recommended to keep this consistent on all entities
export(float, 0, 1) var def_rate : float

export(float) var mood : float
export(float) var max_mood : float
export(bool) var is_turn : bool

# safely gets the reference from a nodepath if it has been setup
export(NodePath) onready var hp_label = get_node(hp_label) as Label if hp_label else null
export(NodePath) onready var atk_label = get_node(atk_label) as Label if atk_label else null
export(NodePath) onready var def_label = get_node(def_label) as Label if def_label else null
export(NodePath) onready var spd_label = get_node(spd_label) as Label if spd_label else null
export(NodePath) onready var mood_label = get_node(mood_label) as Label if mood_label else null

export(NodePath) onready var mood_bar = get_node(mood_bar) as ProgressBar if mood_bar else null
export(NodePath) onready var selfie_anim = get_node(selfie_anim) as AnimationPlayer if selfie_anim else null

signal turn_passed
signal damaged(dmg)

func _ready() -> void:
	# This makes sure that all subclass is trully ready
	var _dump = connect("ready", self, "_setup_stats")


func _setup_stats() -> void:
	_setup_stat_bar(max_mood, mood_bar)
	_updt_stat_bar(mood, mood_bar)
	_updt_stats()


# Updates all of stats ui
func _updt_stats() -> void:
	_updt_stat_label(hp, hp_label)
	_updt_stat_label(atk, atk_label)
	_updt_stat_label(def, def_label)
	_updt_stat_label(spd, spd_label)
	_updt_stat_label(mood, mood_label)


func hit(dmg : float) -> void:
	dmg -= def * def_rate
	dmg = max(dmg, 0)
	
	hp -= dmg
	hp = max(hp, 0)
	
	_updt_hp()
	emit_signal("damaged", dmg)


# Everything that needs to be checked when hp is modified
func _updt_hp() -> void:
	if hp <= 0 : kill()
	_updt_stat_label(hp, hp_label)


# For assigning a label txt with numbers
func _updt_stat_label(val : float, label : Label) -> void:
	var txt := str(stepify(val, 0.1))
	_updt_label(txt, label)


# Safely modifies a label reference
func _updt_label(txt : String, label : Label) -> void:
	if !label : return
	label.text = txt
	


func _setup_stat_bar(max_val : float, bar : ProgressBar) -> void:
	if !bar : return
	var min_val := bar.min_value
	
	# Min and max values in bar must never be the same
	if min_val == max_val : return
	bar.max_value = max_val


# For changing values of a progress bar
func _updt_stat_bar(val : float, bar : ProgressBar) -> void:
	if !bar : return
	bar.value = val


# Codes that need to run after the turn
func _finish_turn() -> void:
	is_turn = false


# Gives the turn to the next entity
func _pass_turn() -> void:
	emit_signal("turn_passed")


func _play_anim(anim_name : String, anim : AnimationPlayer) -> void:
	if !anim : return
	var has_anim : bool = anim.has_animation(anim_name)
	if !has_anim : return
	
	anim.play(anim_name)


# Safely sets a value on a node
func _safe_set(ref : Node, property : String, val) -> void:
	if !ref : return
	ref.set(property, val)


"""
	Placeholder functions below, pls don't delete
"""

func kill() -> void:
	pass


func turn() -> void:
	is_turn = true

