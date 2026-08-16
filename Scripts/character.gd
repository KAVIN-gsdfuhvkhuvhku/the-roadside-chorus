class_name Character
extends Node

enum Name{
	YOU,
	GRANDMA,
	MONTY
}

const CHARACTER_DETAILS: Dictionary = {
	Name.YOU: {
		"name": "You",
		"age": 18,
		"sprite_frames" : preload("res://Resources/Protagonist_sprites.tres")
	},
	
	Name.GRANDMA: {
		"name": "Grandma",
		"age": 68,
		"sprite_frames" : preload("res://Resources/Grandma_sprites.tres")
	}
}

static func get_enum_from_String(String_value: String) -> int:
	var upper_String = String_value.to_upper()
	if Name.has(upper_String):
		return Name[upper_String]
	else:
		push_error("Invalid Character name: " + String_value)
		return -1
