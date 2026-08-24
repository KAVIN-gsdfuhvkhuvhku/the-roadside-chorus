extends Node2D

@onready var character_sprite = %CharacterSprite
@onready var dialog_ui = %dialog_ui
@onready var background = %Background
#@onready var character: Character = %Character

var transition_effect: String = "fade"
var dialog_file: String = "res://Resources/story/first_scene.json"
var dialog_index: int = 0
var dialog_lines: Array = []

func _ready():
	#load dialogue
	dialog_lines = load_dialog(dialog_file)
	dialog_index = 0
	dialog_ui.text_animation_done.connect(_on_text_animation_done)
	dialog_ui.choice_selected.connect(_on_choice_selected)
	SceneManager.transition_out_completed.connect(_on_transition_out_completed)
	SceneManager.transition_in_completed.connect(_on_transition_in_completed)
	#process first line of the dialogue before it is displayed
	SceneManager.transition_in()
	
func _input(event):
	var line = dialog_lines[dialog_index]
	var has_choices = line.has("choices")
	if event.is_action_pressed("next_line") and not has_choices:
		if dialog_ui.animate_text:
			dialog_ui.skip_text_animation()
		else:
			if dialog_index < len(dialog_lines) - 1:
					dialog_index += 1
					process_current_line()

func process_current_line():
	if dialog_index >= dialog_lines.size() or dialog_index < 0:
		printerr("Error: dialogue index is out of bounds: ", dialog_index)
		return
		
	#extract current line
	
		
	var line = dialog_lines[dialog_index]
	
	
	#check if its the end of the scene
	if line.has("next_scene"):
		var next_scene = line["next_scene"]
		dialog_file = "res://Resources/story/" + next_scene + ".json" if !next_scene.is_empty() else ""
		transition_effect = line.get("transition", "fade")
		SceneManager.transition_out(transition_effect)
		return
	
	#check if we need to change the location
	if line.has("location"):
		#change the background image automatically in a new scene
		var background_file = "res://assets/images/" + line["location"] + ".png"
		background.texture = load(background_file)
		#proceed to the next line without waiting for the user input
		dialog_index += 1
		process_current_line()
		return
	
	#Check if this is a goto command
	if line.has("goto"):
		dialog_index = get_anchor_position(line["goto"])
		process_current_line()
		return
	
	#check if this is just a anchor declaration, which isnt displayable content
	if line.has("anchor"):
		dialog_index += 1
		process_current_line()
		return
	#UPDATE CHARACTER sprites accordingly , defaulting to the speaker command if show character is not present
	if line.has("show_character"):
		var character_name = Character.get_enum_from_string(line["show_character"])
		character_sprite.change_character(character_name, false, line.get("expression", ""))
	elif line.has("speaker"):
		var character_name = Character.get_enum_from_string(line["speaker"])
		character_sprite.change_character(character_name, true, line.get("expression", ""))
	
	
	if line.has("choices"):
		#display choices
		dialog_ui.display_choices(line["choices"])
	elif line.has("text"):
		#READING THE CURRENT LINE OF DIALOGUE
		var speaker_name = Character.get_enum_from_string(line["speaker"])
		dialog_ui.change_line(speaker_name, line["text"])
	else:
		#no choice or line of dialogue
		dialog_index += 1
		process_current_line()
		return

func get_anchor_position(anchor: String):
	#find the anchor with the matching name
	for i in range(dialog_lines.size()):
		if dialog_lines[i].has("anchor") and dialog_lines[i]["anchor"] == anchor:
			return i
			
	#if the anchor wasn't found:
	printerr("Error: Could not find anchor '" + anchor + "'")
	return null

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
	
func _on_choice_selected(anchor: String):
	dialog_index = get_anchor_position(anchor)
	process_current_line()
	
func _on_transition_out_completed():
	#load the new dialogue!
	if !dialog_file.is_empty():
		dialog_lines = load_dialog(dialog_file)
		dialog_index = 0
		var first_line = dialog_lines[dialog_index]
		if first_line.has("location"):
			background.texture = load("res://assets/images/" + first_line["location"] + ".png")
			dialog_index =+ 1
		SceneManager.transition_in(transition_effect)
	else:
		print("You've finished the game!")
	
func _on_transition_in_completed():
	#Start processing the dialogue
	process_current_line()
	
	
