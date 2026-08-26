extends Control

# File paths are constants so we define them once and avoid typos.
const PEKAPEKA_IMAGE_PATH := "res://Imported/HabitatFragmentation/img/Pekapeka.png"
const THEME_PATH := "res://Resources/new_theme.tres"
const DIALOG_FONT_PATH := "res://assets/Fonts/VT323/VT323-Regular.ttf"

# BBCode text lets us style the heading and bullet points inside RichTextLabel.
const FACTS_TEXT := "[center]Long-tailed Bat / Pekapeka:[/center]

[indent]• Native and endemic to New Zealand found across mainland New Zealand and several offshore islands.[/indent]

[indent]• Long-tailed bats live around native forests and forest edges, where they roost in old trees and feed on insects.[/indent]

[indent]• Fun fact: They can fly at up to 60 km/h and use echolocation to find their food.[/indent]

[indent]• Habitat fragmentation: The loss and separation of forests through new roads reduce access to important feeding areas and roosting trees, making it harder for bats to survive.[/indent]

[indent]• Conservation status: Threatened - Nationally Critical.[/indent]"

func _ready():
	# Load and show the bat image.
	var img := Image.new()
	if img.load(PEKAPEKA_IMAGE_PATH) == OK:
		$CanvasLayer/Margin/Layout/FishImage.texture = ImageTexture.create_from_image(img)

	# Put the facts text into the scrollable facts panel.
	$CanvasLayer/Margin/Layout/FactsScroll/Facts.text = FACTS_TEXT
	var game_theme := load(THEME_PATH) as Theme
	if game_theme:
		$CanvasLayer/Margin.theme = game_theme

	# Apply the same game font to keep the UI style consistent.
	var game_font: FontFile = load(DIALOG_FONT_PATH) as FontFile
	if game_font:
		$CanvasLayer/Margin/Layout/Title.add_theme_font_override("font", game_font)
		$CanvasLayer/Margin/Layout/FactsScroll/Facts.add_theme_font_override("normal_font", game_font)
		$CanvasLayer/Margin/Layout/ContinueButton.add_theme_font_override("font", game_font)

	# When Continue is pressed, run the function below.
	$CanvasLayer/Margin/Layout/ContinueButton.pressed.connect(_on_continue_pressed)

func _on_continue_pressed():
	# Move to the end screen after the player reads the facts.
	get_tree().change_scene_to_file("res://Imported/HabitatFragmentation/Scenes/end_screen.tscn")
