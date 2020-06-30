extends Node


class Dct:
	# Extracts a variable and assigns it as the key of the object
	static func make_obj_list_key(obj_list : Array, key_name : String) -> Dictionary:
		var rslt := {}
		for obj in obj_list:
			var is_obj = typeof(obj) == TYPE_OBJECT
			if !is_obj : continue
			
			var key = obj.get(key_name)
			rslt[key] = obj
		return rslt
