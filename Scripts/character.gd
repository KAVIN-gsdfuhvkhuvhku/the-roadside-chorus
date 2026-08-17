#class_name Character
extends Node2D
@onready var sprite = $AnimatedSprite2D

const CHARACTER_FRAMES = {
	"You" : preload("res://Resources/Protagonist_sprites.tres")
	"Grandma" : preload("res://Resources/Grandma_sprites.tres")
	}


static func get_enum_from_string(string_value: String) -> int:
	var upper_string = string_value.to_upper()
	if Name.has(upper_string):
		return Name[upper_string]
	else:
		push_error("Invalid Character name: " + string_value)
		return -1
