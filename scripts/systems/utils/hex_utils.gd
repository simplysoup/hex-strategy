extends Node
class_name HexUtils

static func map_to_offset(cell_position: Vector2i):
	var offset = cell_position
	offset.x = cell_position.x - 11
	offset.y = cell_position.y - 5
	return offset

static func offset_to_map(cell_position: Vector2i):
	var map_coords = cell_position
	map_coords.x = cell_position.x + 11
	map_coords.y = cell_position.y + 5
	return map_coords

static func offset_to_cube(cell_position: Vector2i):
	var q = cell_position.x
	var r = cell_position.y - (cell_position.x + (cell_position.x & 1)) / 2
	var s = -q - r
	return Vector3i(q, r, s)
	
static func cube_to_offset(cell_position: Vector3i) -> Vector2i:
	var x = cell_position.x
	var y = cell_position.y + (cell_position.x + (cell_position.x & 1)) / 2
	return Vector2i(x, y)
	
static func cube_to_map(cell_position: Vector3i):
	return offset_to_map(cube_to_offset(cell_position))
	
static func map_to_cube(cell_position: Vector2i) -> Vector3i:
	return offset_to_cube(map_to_offset(cell_position))
