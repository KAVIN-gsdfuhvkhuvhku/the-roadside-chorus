extends Control

# File paths are constants so we define them once and avoid typos.
const INANGA_IMAGE_PATH := "res://Imported/HabitatFragmentation/img/Īnanga.png"
const THEME_PATH := "res://Resources/new_theme.tres"
const DIALOG_FONT_PATH := "res://assets/Fonts/VT323/VT323-Regular.ttf"

# BBCode text lets us style the heading and bullet points inside RichTextLabel.
const FACTS_TEXT := "[center]Īnanga:[/center]

[indent]• Native freshwater fish found in streams, rivers, wetlands and estuaries around New Zealand.[/indent]

[indent]• Īnanga need to move between different habitats during their life cycle. Barriers such as culverts and dams can prevent them from reaching important spawning and feeding areas.[/indent]

[indent]• Fun fact: Īnanga are one of the main fish species that make up whitebait.[/indent]

[indent]• Habitat fragmentation: When waterways become disconnected, īnanga can lose access to the habitats they need to survive.[/indent]"

func _ready():
	# Load and show the fish image.
	var fish_tex := load(INANGA_IMAGE_PATH) as Texture2D
	if fish_tex:
		$CanvasLayer/Margin/Layout/FishImage.texture = fish_tex
	else:
		printerr("Failed to load texture resource: ", INANGA_IMAGE_PATH)

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
