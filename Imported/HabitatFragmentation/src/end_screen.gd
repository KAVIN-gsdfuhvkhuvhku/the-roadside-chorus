extends Control

const THEME_PATH := "res://Resources/new_theme.tres"
const DIALOG_FONT_PATH := "res://assets/Fonts/VT323/VT323-Regular.ttf"
const START_MENU_PATH := "res://Imported/HabitatFragmentation/Scenes/start_menu.tscn"
const ROADSIDE_MAIN_PATH := "res://Scenes/Main_scene.tscn"

@onready var play_again_button: Button = $CanvasLayer/EndPanel/Content/PlayAgainButton
@onready var exit_button: Button = $CanvasLayer/EndPanel/Content/ExitButton

var _scene_switching := false

func _ready():
	print("[EndScreen] Script version 2026-08-26b loaded")
	# Ensure the background never blocks pointer events in web builds.
	$CanvasLayer/Background.mouse_filter = Control.MOUSE_FILTER_IGNORE

	# Wire signals once so re-entering this scene does not create duplicate handlers.
	if not play_again_button.pressed.is_connected(_on_play_again_pressed):
		play_again_button.pressed.connect(_on_play_again_pressed)
	if not exit_button.pressed.is_connected(_on_exit_pressed):
		exit_button.pressed.connect(_on_exit_pressed)

	apply_ui_theme()

func apply_ui_theme():
	var game_theme := load(THEME_PATH) as Theme
	if game_theme:
		$CanvasLayer/EndPanel.theme = game_theme

	var game_font := load(DIALOG_FONT_PATH) as FontFile
	if game_font:
		$CanvasLayer/EndPanel/Content/Subtitle.add_theme_font_override("normal_font", game_font)
		$CanvasLayer/EndPanel/Content/PlayAgainButton.add_theme_font_override("font", game_font)
		$CanvasLayer/EndPanel/Content/ExitButton.add_theme_font_override("font", game_font)

func _deferred_change_scene(path: String):
	if _scene_switching:
		return
	_scene_switching = true
	var err := get_tree().change_scene_to_file(path)
	if err != OK:
		_scene_switching = false
		printerr("Failed to change scene to: ", path, " error code: ", err)

func _on_play_again_pressed():
	# Return to the start menu to choose a mode again.
	print("[EndScreen] Play Again pressed -> ", START_MENU_PATH)
	call_deferred("_deferred_change_scene", START_MENU_PATH)

func _on_exit_pressed():
	# Return to Roadside Chorus and continue from scene eight.
	print("[EndScreen] Exit pressed -> ", ROADSIDE_MAIN_PATH)
	GameState.habitat_completed = true
	GameState.return_story_dialog_file = "res://Resources/story/eighth_scene.json"
	call_deferred("_deferred_change_scene", ROADSIDE_MAIN_PATH)
