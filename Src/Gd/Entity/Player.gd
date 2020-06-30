class_name Player, "res://Src/Asset/Png/Hero/Normal/HeroNormal1.png"

extends Entity

export(NodePath) onready var name_label = get_node(name_label) as RichTextLabel if name_label else null
export(NodePath) onready var lv_label = get_node(lv_label) as Label if lv_label else null
export(NodePath) onready var hp_bar = get_node(hp_bar) as ProgressBar if hp_bar else null

export(PackedScene) var win_pck : PackedScene
export(PackedScene) var gg_pck : PackedScene

export(int) var lv : int
export(float) var max_hp : float
export(String) var bbcode_affix : String

signal stat_updt(hp, atk, def, spd)


func _ready() -> void:
	_connect_upgr_btn()


func _connect_upgr_btn() -> void:
	get_tree().call_group("skill_btn", "connect", "apply_effect", self, "_upgrade")


func _upgrade(upgr_hp : float, upgr_atk : float, upgr_def : float, upgr_spd : float) -> void:
	hp += upgr_hp
	atk += upgr_atk
	def += upgr_def
	spd += upgr_spd
	_updt_stats()
	_emit_stats()


func _set_name(txt : String) -> void:
	var bbcode_txt := bbcode_affix + txt
	name_label.bbcode_text = bbcode_txt


func _monster_selected(monster : Monster) -> void:
	var damage := monster.damage
	hp -= damage
	monster.kill()
	
	_updt_stat_label(hp, hp_label)
	_updt_stats()
	_updt_gamestate()


# The win state must always be checked first
func _updt_gamestate() -> void:
	var is_win := _is_group_zero("Monster")
	var is_lost := _is_group_zero("Selectable")
	printt(is_win, is_lost, get_tree().get_nodes_in_group("Monster"))
	
	match true:
		is_win : _win()
		is_lost : _lost()


func _is_group_zero(group : String) -> bool:
	var count := get_tree().get_nodes_in_group(group).size()
	var is_zero := count == 0
	return is_zero


func _win() -> void:
	_add_popup(win_pck)


func _lost() -> void:
	print("lostt")
	_add_popup(gg_pck)


func _add_popup(pck : PackedScene) -> void:
	var curr_scn := get_tree().current_scene
	var pck_ins := pck.instance()
	curr_scn.add_child(pck_ins)


# Inherited functions, is automatically called by parent class
func _setup_stats() -> void:
	._setup_stats()
	_setup_stat_bar(max_hp, hp_bar)


func _updt_stats() -> void:
	._updt_stats()
	
	_updt_stat_label(lv, lv_label)
	_updt_stat_bar(hp, hp_bar)
	_emit_stats()


# Responsible for setting up a safe communication with a monster
func _connect_monster(monster : Monster) -> void:
	var _err = connect("stat_updt", monster, "updt_damage")
	_err = monster.connect("selected", self, "_monster_selected")
	
	monster.updt_damage(hp, atk, def, spd)


func _emit_stats() -> void:
	emit_signal("stat_updt", hp, atk, def, spd)


func _updt_hp() -> void:
	._updt_hp()
	_updt_stat_bar(hp, hp_bar)

