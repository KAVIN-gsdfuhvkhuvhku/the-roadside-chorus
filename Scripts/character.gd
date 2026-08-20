class_name Character
extends Node

enum Name{
	YOU,
	GRANDMA
}

const CHARACTER_DETAILS: Dictionary = {
	Name.YOU:{
		"name": "You",
		"age": "19Y",
		"flower": "Marigolds",
		"type": "human",
		"sprite_frames": preload("res://Resources/Protagonist_sprites.tres")
	},
	
	Name.GRANDMA:{
		"name": "Grandma",
		"age": "68Y",
		"flower": "Dahlias",
		"type": "human",
		"sprite_frames": preload("res://Resources/Grandma_sprites.tres")
	}
}

static func get_enum_from_string(string_value: String) -> int:
	var upper_string = string_value.to_upper()
	if Name.has(upper_string):
		return Name[upper_string]
	else:
		push_error("Invalid Character name: " + string_value)
		return -1
