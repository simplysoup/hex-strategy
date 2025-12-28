# res://scripts/systems/board_controller.gd
extends Node

class_name BoardController

var board := {} # Dictionary<Vector3i, Unit>

func is_tile_valid(tile: Vector3i, ground: TileMapLayer) -> bool:
	return ground.get_cell_source_id(HexUtils.cube_to_map(tile)) != -1

func is_tile_occupied(tile: Vector3i) -> bool:
	return board.has(tile)

func place_unit(unit: Unit, tile: Vector3i, ground: TileMapLayer) -> bool:
	if not is_tile_valid(tile, ground) or is_tile_occupied(tile):
		return false
	board[tile] = unit
	unit.tile_pos = tile
	unit.position = HexUtils.cube_to_map(tile)
	if unit.get_parent() == null:
		ground.get_parent().add_child(unit)
	return true

func remove_unit(unit: Unit):
	board.erase(unit.tile_pos)
	unit.queue_free()

func spawn_unit(
	tile: Vector3i, 
	allegiance: Enums.Allegiance, 
	movement_speed: int, 
	ground: TileMapLayer
) -> Unit:
	if board.has(tile):
		return
	var unit := preload("res://scenes/Unit.tscn").instantiate()
	unit.allegiance = allegiance
	unit.tile_pos = tile
	unit.position = ground.map_to_local(HexUtils.cube_to_map(tile))
	unit.movement_speed = movement_speed
	board[tile] = unit
	ground.get_parent().add_child(unit)
	
	return unit

func move_unit(unit: Unit, tile: Vector3i, ground: TileMapLayer):
	board.erase(unit.tile_pos)
	unit.tile_pos = tile
	unit.position = ground.map_to_local(HexUtils.cube_to_map(tile))
	board[tile] = unit
	
func get_units() -> Array[Unit]:
	var units: Array[Unit] = []
	for u in board.values():
		units.append(u)
	return units
