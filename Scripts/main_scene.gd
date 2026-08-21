extends Node2D

@onready var character_sprite = %CharacterSprite
@onready var dialog_ui = %dialog_ui
#@onready var character: Character = %Character

var dialog_index: int = 0

var dialog_lines: Array = []

func _ready():
	#load dialogue
	dialog_lines = load_dialog("res://Resources/story/story.json")
	dialog_index = 0
	dialog_ui.text_animation_done.connect(_on_text_animation_done)
	#process first line of the dialogue before it is displayed
	process_current_line()
	
func _input(event):
	if event.is_action_pressed("next_line"):
		if dialog_ui.animate_text:
			dialog_ui.skip_text_animation()
		else:
			if dialog_index < len(dialog_lines) - 1:
					dialog_index += 1
					process_current_line()

func parse_line(line: String):
	var line_info = line.split(":")
	assert(len(line_info) >= 2)
	return {
		"speaker_name": line_info[0],
		"dialog_line": line_info[1]
	}

func process_current_line():
	var line = dialog_lines[dialog_index]
	var line_info = parse_line(line)
	var character_name= Character.get_enum_from_string(line_info["speaker_name"])
	dialog_ui.change_line(character_name, line_info["dialog_line"])
	character_sprite.change_character(character_name)
	
func load_dialog(file_path):
	#CHECK IF THE FILE EXISTS
	if not FileAccess.file_exists(file_path):
		printerr("Error: File does not exist: ", file_path)
		return null
		
	#open the file
	var file = FileAccess.open(file_path, FileAccess.READ)
	#JUST IN CASE THE FILE OPENING FAILS....
	if file == null:
		printerr("Error: Failed to open file: ", file_path)
		return null
	
	#read the content as text
	var content = file.get_as_text()
	
	#parse the json
	var json_content = JSON.parse_string(content)
	#THIS CAN ALSO FAIL: check if the parsing was successful
	if json_content == null:
		printerr("Error: failed to parse JSON from file: ", file_path)
		return null
	
	#return the dialogue
	return json_content
	
func _on_text_animation_done():
	character_sprite.play_idle_animation()
