class_name SkillBtn, "res://Src/Asset/Png/Skill/Fireball.png"

extends TextureButton

export(float) var hp : float
export(float) var atk : float
export(float) var def : float
export(float) var spd : float

signal apply_effect(hp, atk, def, spd)


# Only called when activated/press
func _pressed() -> void:
	emit_signal("apply_effect", hp, atk, def, spd)


