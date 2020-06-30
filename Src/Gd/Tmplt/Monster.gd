class_name Monster, "res://Src/Asset/Png/Monster/MinionOrc/minion_orc1.png"

extends Entity

export(NodePath) onready var damage_label = get_node(damage_label) as Label if damage_label else null
export(NodePath) onready var hitbox_anim = get_node(hitbox_anim) as AnimationPlayer if hitbox_anim else null
export(NodePath) onready var selfie_rect = get_node(selfie_rect) as TextureRect if selfie_rect else null
export(NodePath) onready var motto_label = get_node(motto_label) as RichTextLabel if motto_label else null
export(NodePath) onready var disable_rect = get_node(disable_rect) as ColorRect if disable_rect else null

export(AnimatedTexture) var selfie_tex : AnimatedTexture
export(String, MULTILINE) var motto_txt : String
export(float) var damage : float

# Will be overwritten be dungeon
export(float, 0, 1) var stat_bump : float
export(Array, String) var stat_list : Array

signal player_hit(dmg)
signal selected(ref)
signal anim_finished
signal dead


func _ready() -> void:
	_bump_stats()
	_setup_visual()


# (monster.hp / (player.atk-monster.def) )x(player.spd/monster.spd) x (monster.atk-player.def)
func updt_damage(player_hp : float, player_atk : float, player_def : float, player_spd : float) -> void:
	damage = abs((hp / (player_atk - def)) * (player_spd / spd) * (atk - player_def))
	
	_updt_hitbox(player_hp)
	_updt_stat_label(damage, damage_label)


func _updt_group(is_immune : bool) -> void:
	if is_immune: _leave_group("Selectable")
	else : add_to_group("Selectable")


func _leave_group(group : String) -> void:
	var is_in := is_in_group("Selectable")
	if !is_in : return 
	
	remove_from_group(group)


func _updt_hitbox(player_hp : float) -> void:
	if !disable_rect : return
	
	var is_immune := player_hp <= damage
	disable_rect.set_visible(is_immune)
	_updt_group(is_immune)


func _bump_stats() -> void:
	for stat in stat_list:
		var base : float = get(stat)
		var bumped := base * stat_bump
		set(stat, bumped)


func _setup_stats() -> void:
	._setup_stats()
	


# Can only overwrite those with valid node reference
func _setup_visual() -> void:
	_safe_set(selfie_rect, "texture", selfie_tex)
	_safe_set(motto_label, "text", motto_txt)


# Is automatically called
func turn() -> void:
	_play_anim("HulkSmash", selfie_anim)


func _hit_player() -> void:
	emit_signal("player_hit", atk)


func _updt_hp() -> void:
	_updt_stat_label(hp, hp_label)
	_play_anim("hurt", selfie_anim)


func kill() -> void:
	.kill()
	emit_signal("dead")
	remove_from_group("Monster")
	queue_free()


func _atk_finished(_anim_name : String) -> void:
	emit_signal("anim_finished")
	._updt_hp()


# Button Events
func _pressed() -> void:
	emit_signal("selected", self)


func _hovered() -> void:
	_play_anim("Hover", hitbox_anim)


func _unhovered() -> void:
	_play_anim("Unhover", hitbox_anim)


