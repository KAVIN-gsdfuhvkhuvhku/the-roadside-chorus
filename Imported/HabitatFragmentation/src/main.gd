extends Area2D

# Current tile order on the board.
var animal_zones = []
# Correct solved tile order used to check if the puzzle is complete.
var winning_arrangement = []
# Stores one click/tap event so we can process it in _process().
var active_touch = false
# 3 for easy mode, 4 for hard mode.
var grid_size = 4
# Pixel size of one grid square.
var cell_size = 250.0
# Board width/height in pixels.
var board_size = 1000.0
# Reference to the empty slot tile.
var empty_tile = null
var puzzle_solved = false
var is_celebrating = false
# Tile used as the animated "travelling" tile after solving.
var bird_tile_node_name = "Tile1"
const DIALOG_FONT_PATH := "res://assets/Fonts/VT323/VT323-Regular.ttf"
const THEME_PATH := "res://Resources/new_theme.tres"
const EASY_CELEBRATION_STEP_DURATION := 0.35
const HARD_CELEBRATION_STEP_DURATION := 0.45
const EASY_TILE_TEXTURE_PATHS := [
	"res://Imported/HabitatFragmentation/img/easy_tile1.png",
	"res://Imported/HabitatFragmentation/img/easy_tile2.png",
	"res://Imported/HabitatFragmentation/img/easy_tile3.png",
	"res://Imported/HabitatFragmentation/img/easy_tile4.png",
	"res://Imported/HabitatFragmentation/img/easy_tile5.png",
	"res://Imported/HabitatFragmentation/img/easy_tile6.png",
	"res://Imported/HabitatFragmentation/img/easy_tile7.png",
	"res://Imported/HabitatFragmentation/img/easy_tile8.png"
]
const HARD_TILE_TEXTURE_PATHS := [
	"res://Imported/HabitatFragmentation/img/tile1.png",
	"res://Imported/HabitatFragmentation/img/tile2.png",
	"res://Imported/HabitatFragmentation/img/tile3.png",
	"res://Imported/HabitatFragmentation/img/tile4.png",
	"res://Imported/HabitatFragmentation/img/tile5.png",
	"res://Imported/HabitatFragmentation/img/tile6.png",
	"res://Imported/HabitatFragmentation/img/tile7.png",
	"res://Imported/HabitatFragmentation/img/tile8.png",
	"res://Imported/HabitatFragmentation/img/tile9.png",
	"res://Imported/HabitatFragmentation/img/tile10.png",
	"res://Imported/HabitatFragmentation/img/tile11.png",
	"res://Imported/HabitatFragmentation/img/tile12.png",
	"res://Imported/HabitatFragmentation/img/tile13.png",
	"res://Imported/HabitatFragmentation/img/tile14.png",
	"res://Imported/HabitatFragmentation/img/tile15.png"
]
const EMPTY_TILE_TEXTURE_PATH := "res://Imported/HabitatFragmentation/img/empty.png"

# Runs once when this scene starts.
func _ready():
	# Read selected mode and build the puzzle before gameplay begins.
	configure_mode()
	update_board_metrics()
	initialize_wildlife_puzzle()
	# Prepare win popup style (used by legacy flow and kept for compatibility).
	configure_win_dialog()
	# Keep the board responsive when screen size changes.
	get_viewport().size_changed.connect(_on_viewport_size_changed)
	$CanvasLayer/WinDialog.confirmed.connect(_on_win_dialog_confirmed)
	$CelebrationTile.visible = false

func configure_win_dialog():
	var win_dialog: AcceptDialog = $CanvasLayer/WinDialog
	var game_theme := load(THEME_PATH) as Theme
	if game_theme:
		win_dialog.theme = game_theme
	var continue_button: Button = $CanvasLayer/WinDialog.get_ok_button()
	continue_button.custom_minimum_size = Vector2(240, 88)
	var dialog_font: FontFile = load(DIALOG_FONT_PATH) as FontFile
	if dialog_font:
		continue_button.add_theme_font_override("font", dialog_font)
	continue_button.add_theme_font_size_override("font_size", 28)
	apply_dialog_button_style_override(continue_button, "hover")
	apply_dialog_button_style_override(continue_button, "focus")
	apply_dialog_button_style_override(continue_button, "pressed")

	if dialog_font:
		var dialog_label: Label = win_dialog.get_label()
		dialog_label.add_theme_font_override("font", dialog_font)
		dialog_label.add_theme_font_size_override("font_size", 30)
		dialog_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

func apply_dialog_button_style_override(button: Button, style_name: String):
	var style_override = button.get_theme_stylebox(style_name).duplicate()
	if style_override is StyleBoxTexture:
		style_override.texture_margin_left = 20.0
		style_override.texture_margin_right = 20.0
		button.add_theme_stylebox_override(style_name, style_override)

func initialize_wildlife_puzzle():
	# Tile nodes available in the scene. Easy mode uses the first 8 + empty tile.
	var all_tiles = [
		$Tile1, $Tile2, $Tile3, $Tile4,
		$Tile5, $Tile6, $Tile7, $Tile8,
		$Tile9, $Tile10, $Tile11, $Tile12,
		$Tile13, $Tile14, $Tile15
	]
	empty_tile = $Tile16

	for tile in all_tiles:
		tile.visible = false

	animal_zones = []
	if grid_size == 3:
		# Swap in the 3x3 image set for easy mode.
		apply_easy_mode_textures(all_tiles)
		for i in range(8):
			all_tiles[i].visible = true
			animal_zones.append(all_tiles[i])
		animal_zones.append(empty_tile)
	else:
		apply_hard_mode_textures(all_tiles)
		for tile in all_tiles:
			tile.visible = true
			animal_zones.append(tile)
		animal_zones.append(empty_tile)

	empty_tile.visible = true
	relayout_tiles()
	winning_arrangement = animal_zones.duplicate()
	# Shuffle after setting the solved reference order.
	shuffle_crossing_tiles()

func configure_mode():
	# Default to hard mode if no state is set yet.
	grid_size = 4
	if has_node("/root/GameState"):
		grid_size = int(get_node("/root/GameState").grid_size)
	grid_size = clamp(grid_size, 3, 4)
	if grid_size == 4:
		bird_tile_node_name = "Tile4"
	else:
		bird_tile_node_name = "Tile3"

func apply_easy_mode_textures(all_tiles: Array):
	# Replace Tile1..Tile8 textures with cropped images from Tiles3X3.
	for i in range(min(8, all_tiles.size())):
		var tex := load_image_texture(EASY_TILE_TEXTURE_PATHS[i])
		if tex:
			all_tiles[i].texture = tex
	var empty_tex := load_image_texture(EMPTY_TILE_TEXTURE_PATH)
	if empty_tex:
		empty_tile.texture = empty_tex

func load_image_texture(path: String) -> Texture2D:
	# In exports, source PNG files may be remapped; loading as a resource is web-safe.
	var tex := load(path) as Texture2D
	if tex == null:
		printerr("Failed to load texture resource: ", path)
		return null
	return tex

func apply_hard_mode_textures(all_tiles: Array):
	for i in range(min(HARD_TILE_TEXTURE_PATHS.size(), all_tiles.size())):
		var tex := load_image_texture(HARD_TILE_TEXTURE_PATHS[i])
		if tex:
			all_tiles[i].texture = tex
	var empty_tex := load_image_texture(EMPTY_TILE_TEXTURE_PATH)
	if empty_tex:
		empty_tile.texture = empty_tex

func update_board_metrics():
	# Make the board a centered square that fits inside the viewport.
	var viewport_size = get_viewport_rect().size
	board_size = min(viewport_size.x, viewport_size.y)
	cell_size = board_size / float(grid_size)
	position = (viewport_size - Vector2(board_size, board_size)) * 0.5

	var rect_shape := $CollisionShape2D.shape as RectangleShape2D
	if rect_shape:
		rect_shape.size = Vector2(board_size, board_size)
	$CollisionShape2D.position = Vector2(board_size * 0.5, board_size * 0.5)

func _on_viewport_size_changed():
	# Recalculate sizes and positions when device/window size changes.
	update_board_metrics()
	relayout_tiles()
	resize_celebration_tile()

func relayout_tiles():
	# Scale each sprite to fit one grid cell, then place it by row/column.
	for i in range(animal_zones.size()):
		if animal_zones[i].texture == null:
			printerr("Missing texture for tile: ", animal_zones[i].name)
			continue
		var texture_size = animal_zones[i].texture.get_size().x
		var scale_factor = cell_size / texture_size
		animal_zones[i].scale = Vector2(scale_factor, scale_factor)

		var row = i / grid_size
		var col = i % grid_size
		animal_zones[i].position = Vector2(
			(col + 0.5) * cell_size,
			(row + 0.5) * cell_size
		)

func resize_celebration_tile():
	if !$CelebrationTile.texture:
		return

	# Keep celebration tile size matching one puzzle cell.
	var texture_size = $CelebrationTile.texture.get_size().x
	var scale_factor = cell_size / texture_size
	$CelebrationTile.scale = Vector2(scale_factor, scale_factor)
	
func shuffle_crossing_tiles():
	var last_zone = 99
	var second_last_zone = 98
	var total_tiles = animal_zones.size()
	
	# Shuffle using only legal moves so every generated puzzle is solvable.
	for attempt in range(0, 1000):
		var selected_zone = randi() % total_tiles
		if animal_zones[selected_zone] != empty_tile and selected_zone != last_zone and selected_zone != second_last_zone:
			var grid_row = int(animal_zones[selected_zone].position.y / cell_size)
			var grid_col = int(animal_zones[selected_zone].position.x / cell_size)
			validate_adjacent_paths(grid_row, grid_col)
			second_last_zone = last_zone
			last_zone = selected_zone
			
# Called every frame. Processes one stored click/tap at a time.
func _process(delta):
	if puzzle_solved or is_celebrating:
		return

	if active_touch:
		var touch_event_copy = active_touch
		active_touch = false
		
		# Convert global event position to local coordinates relative to this Area2D.
		var local_pos = to_local(touch_event_copy.global_position)
		var grid_row = int(local_pos.y / cell_size)
		var grid_col = int(local_pos.x / cell_size)
		
		if grid_row >= 0 and grid_row < grid_size and grid_col >= 0 and grid_col < grid_size:
			# Move tile if legal, then check win condition.
			validate_adjacent_paths(grid_row, grid_col)
			if animal_zones == winning_arrangement:
				puzzle_solved = true
				play_solved_animation()

func validate_adjacent_paths(grid_row, grid_col):
	# Find whether the selected tile is next to the empty tile.
	var found_safe_path = false
	var scan_complete = false
	var current_index = grid_row * grid_size + grid_col
	
	if current_index < 0 or current_index >= animal_zones.size() or animal_zones[current_index] == null:
		return
		
	while !found_safe_path and !scan_complete:
		var target_position = animal_zones[current_index].position
		if grid_row < grid_size - 1:
			target_position.y += cell_size
			found_safe_path = locate_safe_crossing_zone(target_position, current_index)
			target_position.y -= cell_size
		if grid_row > 0:
			target_position.y -= cell_size
			found_safe_path = locate_safe_crossing_zone(target_position, current_index)
			target_position.y += cell_size
		if grid_col < grid_size - 1:
			target_position.x += cell_size
			found_safe_path = locate_safe_crossing_zone(target_position, current_index)
			target_position.x -= cell_size
		if grid_col > 0:
			target_position.x -= cell_size
			found_safe_path = locate_safe_crossing_zone(target_position, current_index)
			target_position.x += cell_size
		scan_complete = true
			
func locate_safe_crossing_zone(target_position, current_index):
	# Convert neighbour position to array index and swap if it is the empty tile.
	var target_row = int(target_position.y / cell_size)
	var target_col = int(target_position.x / cell_size)
	var target_array_pos = target_row * grid_size + target_col
	
	if target_array_pos < 0 or target_array_pos >= animal_zones.size():
		return false
		
	if animal_zones[target_array_pos] == empty_tile:
		swap_animal_positions(current_index, target_array_pos)
		return true
	else:
		return false

func swap_animal_positions(zone_source, zone_destination):
	# Swap both visual positions and array order so logic and display stay aligned.
	var temp_position = animal_zones[zone_source].position
	animal_zones[zone_source].position = animal_zones[zone_destination].position
	animal_zones[zone_destination].position = temp_position
	var temp_animal_node = animal_zones[zone_source]
	animal_zones[zone_source] = animal_zones[zone_destination]
	animal_zones[zone_destination] = temp_animal_node
	
func _input_event(viewport, event, shape_idx):
	if puzzle_solved or is_celebrating:
		return

	# Store click to process on the next frame.
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		active_touch = event

func _on_win_dialog_confirmed():
	# Fallback flow: continue to end screen.
	get_tree().change_scene_to_file("res://Imported/HabitatFragmentation/Scenes/end_screen.tscn")

func play_solved_animation():
	# Lock gameplay during celebration animation.
	is_celebrating = true
	active_touch = false

	var bird_tile := get_node_or_null(bird_tile_node_name) as Sprite2D
	if bird_tile and bird_tile.texture:
		$CelebrationTile.texture = bird_tile.texture
	elif animal_zones.size() > 0 and animal_zones[0].texture:
		$CelebrationTile.texture = animal_zones[0].texture

	resize_celebration_tile()
	$CelebrationTile.modulate = Color(1.0, 1.0, 1.0, 0.9)
	$CelebrationTile.visible = true
	$CelebrationTile.z_index = 200

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	# Hard mode and easy mode use different celebration speeds.
	var step_duration := HARD_CELEBRATION_STEP_DURATION if grid_size == 4 else EASY_CELEBRATION_STEP_DURATION
	var route_indices := get_celebration_route_indices()

	for i in range(route_indices.size()):
		var route_index = route_indices[i]
		var row = route_index / grid_size
		var col = route_index % grid_size
		var target_pos = Vector2((col + 0.5) * cell_size, (row + 0.5) * cell_size)

		if i == 0:
			$CelebrationTile.position = target_pos
		else:
			tween.tween_property($CelebrationTile, "position", target_pos, step_duration)

	await tween.finished
	$CelebrationTile.visible = false
	is_celebrating = false
	# Show species facts screen based on selected mode.
	if grid_size == 4:
		get_tree().change_scene_to_file("res://Imported/HabitatFragmentation/Scenes/inanga_facts.tscn")
	else:
		get_tree().change_scene_to_file("res://Imported/HabitatFragmentation/Scenes/pekapeka_facts.tscn")

func get_celebration_route_indices() -> Array[int]:
	if grid_size == 4:
		# Hard mode path: 4 -> 3 -> 2 -> 1 -> 5 -> 6 -> 7 -> 8 -> 12 -> 11 -> 10 -> 9 -> 13 -> 14 -> 15 -> empty (16).
		return [3, 2, 1, 0, 4, 5, 6, 7, 11, 10, 9, 8, 12, 13, 14, 15]
	if grid_size == 3:
		# Easy mode path: 3 -> 6 -> 5 -> 2 -> 1 -> 4 -> 7 -> 8 -> empty (9).
		return [2, 5, 4, 1, 0, 3, 6, 7, 8]

	var route: Array[int] = []
	for i in range(animal_zones.size() - 1):
		route.append(i)
	return route
