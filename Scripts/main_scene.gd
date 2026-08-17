extends Node2D

@onready var character = %character
@onready var dialog_ui = %dialog_ui

var dialog_index: int = 0

const dialog_lines: Array[String] = [
	"Grandma: Good morning dear, come eat breakfast!",
	"You: of course let me grab our bowls",
	"Grandma: nom nom… By the way dear, congrats on graduating high school! It feels like just yesterday when I dropped you off for your first day….",
	"You: Thank you, I’m just glad I can relax now~",
]

func _ready():
	dialog_index = 0
	dialog_ui.text_animation_done.connect(_on_text_animation_done)
	#process first line of the dialogue before it is displayed
	process_current_line()
	
func _input(event):
	if event.is_action_pressed("next_line"):
		if dialog_ui.animate_text:
			dialog_ui.skip_text_animation()
		else:
			if dialog_index < len(dialog_lines) -1:
				dialog_index += 1
				process_current_line()

func parse_line(line: String):
	var line_info = line.split(":")
	assert(len(line_info) >= 2)
	return{
		"speaker_name": line_info[0],
		"dialog_line": line_info[1]
	}

func process_current_line():
	var line = dialog_lines[dialog_index]
	var line_info = parse_line(line)
	#var character_name = Character.get_enum_from_string(line_info["speaker_name"])
	dialog_ui.change_line(line_info["speaker_name"], line_info["dialog_line"])
	character.change_character(line_info["speaker_name"])

func _on_text_animation_done():
	character.play_idle_animation()
