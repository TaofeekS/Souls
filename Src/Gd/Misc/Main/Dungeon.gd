extends VBoxContainer

export(Curve) var frontline_curve : Curve
export(Curve) var stat_curve : Curve
export(int) var monster_count : int

export(NodePath) onready var frontline = get_node(frontline) as GridContainer
export(Array, PackedScene) var monster_pck_list : Array

signal turn_finished
signal player_hit(dmg)
signal monster_summoned(ref)

var wave : float


func _ready() -> void:
	_updt_frontline()


# Summons more monsters in the frontline
func _updt_frontline() -> void:
	var frontline_count := _get_curve_val(frontline_curve, wave, monster_count)
	while wave < monster_count:
		var monster_count : int =  frontline.get_child_count()
		var is_full := monster_count >= frontline_count
		if is_full : return
		
		_summon_monster()


func _summon_monster() -> void:
	wave += 1
	
	var monster_ins : Monster = _get_rand_monster()
	if !monster_ins : return
	
	monster_ins.stat_bump = _get_curve_val(stat_curve, wave, monster_count)
	frontline.add_child(monster_ins)
	
	_connect_monster(monster_ins)
	emit_signal("monster_summoned", monster_ins)


func _connect_monster(monster : Entity) -> void:
	var _err = monster.connect("turn_passed", self, "_finish_turn")
	_err = monster.connect("player_hit", self, "_hit_player")
	_err = monster.connect("dead", self, "_updt_frontline")


# Checks if cannot summon more monsters
func _is_frontline_full() -> bool:
	var summoned : int = frontline.get_child_count()
	var frontline_count := _get_curve_val(frontline_curve, wave, monster_count)
	var is_full := summoned >= frontline_count
	
	if is_full : return true
	return false


func _get_curve_val(curve : Curve, val : float, max_val : float) -> float:
	var offset := val / max_val
	var rslt := curve.interpolate(offset)
	return rslt


# Signal shortcut functions
# and also makes sure that the signal is not mistaken as unused
func _finish_turn() -> void:
	emit_signal("turn_finished")


func _hit_player(dmg : float) -> void:
	emit_signal("player_hit", dmg)



func _get_rand_monster() -> Monster:
	if !monster_pck_list : return null
	
	randomize()
	monster_pck_list.shuffle()
	var monster_pck : PackedScene = monster_pck_list.front()
	var ins : Monster = monster_pck.instance()
	return ins
