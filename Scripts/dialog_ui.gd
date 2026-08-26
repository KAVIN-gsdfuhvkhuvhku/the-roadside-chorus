extends Control

signal text_animation_done
signal choice_selected
const ChoiceButtonScene = preload("res://Scenes/player_choice.tscn")
#preload trhe choice scene so that you dont have to redo it every time


@onready var dialog_line = %DialogLine
@onready var speaker_name = %SpeakerName
@onready var text_blip_sound = %TextBlipSound
@onready var text_blip_timer = %TextBlipTimer
@onready var choice_list = %ChoiceList


const ANIMATION_SPEED : int = 30
const NO_SOUND_CHARS : Array = ["?", "!", ".", "~"]
var animate_text : bool = false #to be able to click through the text without having to wait for the typing to stop
var current_visible_characters : int = 0
var current_character_details : Dictionary


# Called when the node enters the scene tree for the first time.
func _ready():
	#hide the choice list
	dialog_line.text = ""
	speaker_name.text = ""
	choice_list.hide()
	text_blip_timer.timeout.connect(_on_text_blip_timeout)
	
	
func _process(delta):
	if animate_text:
		if dialog_line.visible_ratio < 1:
			dialog_line.visible_ratio += (1.0/dialog_line.text.length()) * (ANIMATION_SPEED * delta)
			if dialog_line.visible_characters > current_visible_characters:
				current_visible_characters = dialog_line.visible_characters
				var _last_char = dialog_line.text[current_visible_characters - 1]
		else:
			animate_text = false
			text_animation_done.emit()
			text_blip_timer.stop()
#
func change_line(character_name: Character.Name, line: String):
	current_character_details = Character.CHARACTER_DETAILS[character_name]
	speaker_name.text = current_character_details["name"]
	current_visible_characters = 0
	dialog_line.text = line
	dialog_line.visible_characters = 0
	animate_text = true
	text_blip_timer.start()
	#
	
func display_choices(choices: Array):
	#clear any previous choices
	for child in choice_list.get_children():
		child.queue_free()
	
	#create a new button on the screen for each choice
	for choice in choices:
		var choice_button = ChoiceButtonScene.instantiate()
		choice_button.text = choice["text"]
		#attatch signal to button
		choice_button.pressed.connect(_on_choice_button_pressed.bind(choice["goto"]))
		#add the button to the choices container
		choice_list.add_child(choice_button)
		
	#show the choice list
	choice_list.show()

func skip_text_animation():
	dialog_line.visible_ratio = 1

func _on_text_blip_timeout():
	text_blip_sound.play_sound(current_character_details)

func _on_choice_button_pressed(anchor: String):
	choice_selected.emit(anchor)
	choice_list.hide()
