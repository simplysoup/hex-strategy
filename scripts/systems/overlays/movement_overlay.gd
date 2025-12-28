extends TileOverlay
class_name MovementOverlay

func highlight_movement(unit: Unit, board: Dictionary, ground: TileMapLayer, is_unit_turn: bool = false) -> void:
	clear_highlights()
	var center = unit.tile_pos
	for x in range(-unit.movement_speed, unit.movement_speed + 1):
		for y in range(max(-unit.movement_speed, -x - unit.movement_speed),
					   min(unit.movement_speed, -x + unit.movement_speed) + 1):
			var z = -x - y
			var cube = center + Vector3i(x, y, z)
			var map_pos = HexUtils.cube_to_map(cube)

			if ground.get_cell_source_id(map_pos) == -1:
				continue
			if board.has(cube):
				continue
				
			if is_unit_turn:
				add_highlight(cube, 0)
			else:
				add_highlight(cube, 3)
			
			
