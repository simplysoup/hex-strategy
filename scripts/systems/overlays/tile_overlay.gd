extends Node
class_name TileOverlay

# The TileMapLayer this overlay will use
@export var overlay_layer: TileMapLayer

# Stores active cube coordinates
var highlights: Array = []

# Clears all current highlights
func clear_highlights() -> void:
	if not overlay_layer:
		return
	for cube in highlights:
		overlay_layer.erase_cell(HexUtils.cube_to_map(cube))
	highlights.clear()

# Highlight a single tile
func add_highlight(cube: Vector3i, tile_index: int = 0) -> void:
	if not overlay_layer:
		return
	var map_pos = HexUtils.cube_to_map(cube)
	overlay_layer.set_cell(map_pos, overlay_layer.tile_set.get_source_id(0), Vector2i(tile_index, 0), 0)
	highlights.append(cube)

# Highlight multiple tiles
func add_highlights(cubes: Array, tile_index: int = 0) -> void:
	for cube in cubes:
		add_highlight(cube, tile_index)
