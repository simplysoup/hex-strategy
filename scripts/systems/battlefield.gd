extends Node2D

@onready var ground: TileMapLayer = $Ground
@onready var marker: Node2D = $TileMarkers/Marker
@onready var current_unit_marker: Node2D = $TileMarkers/CurrentUnitMarker
@onready var selected_unit_marker: Node2D = $TileMarkers/SelectedUnitMarker
@onready var offset_label: Label = $MapData/Offset
@onready var cube_label: Label = $MapData/Cube
@onready var selected_unit_label: Label = $MapData/SelectedUnitLabel
@onready var current_unit_label: Label = $MapData/CurrentUnitLabel
@onready var movement_overlay: MovementOverlay = $MovementOverlay
@onready var scheduler: Scheduler = $Scheduler
@onready var board_controller: BoardController = $BoardController


var selected_unit: Unit = null
var current_unit: Unit = null

func _ready() -> void:
	board_controller.spawn_unit(Vector3i(0, 0, 0), Enums.Allegiance.PLAYER, 2, ground)
	board_controller.spawn_unit(Vector3i(1, 1, -2), Enums.Allegiance.ENEMY, 1, ground)
	board_controller.spawn_unit(Vector3i(1, -2, 1), Enums.Allegiance.PLAYER, 1, ground)
	board_controller.spawn_unit(Vector3i(-2, 1, 1), Enums.Allegiance.PLAYER, 1, ground)
	
	_schedule_initial_turns()
	scheduler.connect("unit_turn_started", Callable(self, "_on_unit_turn_started"))
	scheduler.run_next()
	
# Called by Scheduler when a unit's turn begins
func _on_unit_turn_started(unit: Unit) -> void:
	selected_unit = null
	current_unit = unit
	highlight_current_unit(current_unit)
	movement_overlay.clear_highlights()
	if current_unit.allegiance != Enums.Allegiance.PLAYER:
		perform_enemy_turn(current_unit)
		
func perform_enemy_turn(unit: Unit):
	movement_overlay.clear_highlights()
	movement_overlay.highlight_movement(unit, board_controller.board, ground, false)
	if movement_overlay.highlights.size() > 0:
		var destination = movement_overlay.highlights.pick_random()
		board_controller.move_unit(unit, destination, ground)
		movement_overlay.clear_highlights()
	else:
		get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
		
	unit.end_turn(scheduler)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var map_coords = ground.local_to_map(get_local_mouse_position())
		if ground.get_cell_source_id(map_coords) != -1:
			var tile = HexUtils.map_to_cube(map_coords)
			handle_tile_click(tile)

func handle_tile_click(tile: Vector3i):
	if board_controller.is_tile_occupied(tile):
		selected_unit = board_controller.board[tile]
		var is_selected_unit_turn = selected_unit == current_unit
		movement_overlay.highlight_movement(selected_unit, board_controller.board, ground, is_selected_unit_turn)
	elif tile in movement_overlay.highlights and selected_unit == current_unit:
		board_controller.move_unit(selected_unit, tile, ground)
		current_unit.last_action_time = scheduler.current_time
		current_unit.schedule_next_turn(scheduler)
		selected_unit = null
		movement_overlay.clear_highlights()
		scheduler.run_next()
	else:
		selected_unit = null
		movement_overlay.clear_highlights()
		
func _schedule_initial_turns() -> void:
	for unit in board_controller.get_units():
		unit.last_action_time = 0.0
		unit.schedule_next_turn(scheduler)

func _process(_delta: float):
	var mouse_pos = get_local_mouse_position()
	var map_coords = ground.local_to_map(mouse_pos)
	var offset = HexUtils.map_to_offset(map_coords)
	var cube = HexUtils.offset_to_cube(offset)

	if ground.get_cell_source_id(map_coords) != -1:
		highlight_cell(map_coords)
		marker.visible = true
		offset_label.text = "Offset: " + str(offset)
		cube_label.text = "Cube: " + str(cube)

	else:
		marker.visible = false
		offset_label.text = "Offset: "
		cube_label.text = "Cube: "
		
	if current_unit != null:
		current_unit_label.text = "Current Unit: " + str(current_unit.allegiance_name)
		highlight_current_unit(current_unit)
	else:
		current_unit_label.text = "Current Unit: "
		current_unit_marker.visible = false
		
		
	if selected_unit != null:
		selected_unit_label.text = "Selected Unit: " + selected_unit.allegiance_name
		highlight_selected_unit(selected_unit)
	else:
		selected_unit_label.text = "Selected Unit: "
		selected_unit_marker.visible = false
		
		
		
func highlight_cell(map_coords: Vector2i) -> void: 
	marker.position = ground.map_to_local(map_coords)

func highlight_current_unit(unit: Unit) -> void:
	current_unit_marker.position = unit.position
	current_unit_marker.visible = true
	
func highlight_selected_unit(unit: Unit) -> void:
	selected_unit_marker.position = unit.position
	selected_unit_marker.visible = true
	
