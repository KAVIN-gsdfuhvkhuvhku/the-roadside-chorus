class_name Character
extends Node

enum Name{
	YOU,
	GRANDMA,
	HELPER,
	MONTY,
	PUKEKO,
	HEDGEHOG,
	TUI,
	NARRATOR
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
	},
	
	Name.HELPER:{
		"name": "Helper",
		"age": "21Y",
		"flower": "Bleeding-hearts",
		"type": "human",
		"sprite_frames": preload("res://Resources/Helper_sprites.tres")
	},
	
	Name.MONTY:{
		"name": "Monty",
		"age": "6Y",
		"flower": "daisies",
		"type": "animal",
		"sprite_frames": preload("res://Resources/Monty_sprites.tres")
	},
	
	Name.PUKEKO:{
		"name": "Pukeko",
		"age": "4Y",
		"flower": "swamp-lilies",
		"type": "animal",
		"sprite_frames": preload("res://Resources/Pukeko_sprites.tres")
	},
	
	Name.HEDGEHOG:{
		"name": "Hedgehog",
		"age": "1Y",
		"flower": "butter-cups",
		"type": "animal",
		"sprite_frames": preload("res://Resources/Hedgehog_sprites.tres")
	},
	
	Name.TUI:{
		"name": "Tui",
		"age": "2Y",
		"flower": "kowhai",
		"type": "animal",
		"sprite_frames": preload("res://Resources/Tui_sprites.tres")
	},
	
	Name.NARRATOR:{
		"name": "Narrator",
		"age": "??",
		"flower": "??",
		"type": "??",
		"sprite_frames": preload("res://Resources/Narrator_sprites.tres")
	}
}

static func get_enum_from_string(string_value: String) -> int:
	var upper_string = string_value.to_upper()
	if Name.has(upper_string):
		return Name[upper_string]
	else:
		push_error("Invalid Character name: " + string_value)
		return -1
