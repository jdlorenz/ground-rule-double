extends TileMapLayer

@onready var strike_zone_overlay: TileMapLayer = $"../StrikeZoneOverlay"
@onready var strike_zone: TileMapLayer = $"../StrikeZone"
@onready var baseball_sprite: Sprite2D = $"../Baseball"

var previous_hovered_cells : Array = []
var hovered_cells
var is_pitch_thrown : bool = false

func get_cells_within_radius(center: Vector2i, radius: float) -> Array:
	var cells: Array = []

	var radius_min = -ceil(radius)
	var radius_max = ceil(radius)

	for x in range(radius_min, radius_max):
		for y in range(radius_min, radius_max):
			var offset = Vector2i(x, y)
			if offset.length() <= radius:
				cells.append(center + offset)

	return cells

func _process(_delta):
	_hover(6.2)
	pass
	
func _hover(radius: float):
	if is_pitch_thrown == false:
		var mouse_pos: Vector2 = get_global_mouse_position()
		var center_cell: Vector2i = local_to_map(to_local(mouse_pos))
		hovered_cells = get_cells_within_radius(center_cell, radius)
		# Skip if still hovering same cells
		
		if hovered_cells == previous_hovered_cells:
			return

		# Clear old highlights
		for cell in previous_hovered_cells:
			var source_id = strike_zone.get_cell_source_id(cell)
			if source_id != -1:
				var pitch_location_type = strike_zone.tile_set.get_source(source_id).resource_name
				Global.pitchTypeCounts[pitch_location_type]+=-1
			strike_zone_overlay.erase_cell(cell)

		# Apply highlights
		for cell in hovered_cells:
			var source_id = strike_zone.get_cell_source_id(cell)
			if source_id != -1:
				var pitch_location_type = strike_zone.tile_set.get_source(source_id).resource_name
				Global.pitchTypeCounts[pitch_location_type]+=1
			source_id = 1
			var atlas_coord = Vector2i(0,0)
			strike_zone_overlay.set_cell(cell, source_id, atlas_coord)
		
		Global.totalPitchCoverage = len(hovered_cells)
		previous_hovered_cells = hovered_cells

func baseball_appears():
	baseball_sprite.position = Global.pitchGlobalLocation
	baseball_sprite.visible = true
	var tween := get_tree().create_tween()
	tween.tween_property(baseball_sprite, "scale", Vector2(1, 1), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("click"):
		var source_id = 2
		var atlas_coord = Vector2i(0,0)
		for cell in previous_hovered_cells:
			strike_zone_overlay.set_cell(cell, source_id, atlas_coord)
		is_pitch_thrown = true
		Global.pitchLocation = hovered_cells.pick_random()
		Global.pitchGlobalLocation = strike_zone_overlay.map_to_local(Global.pitchLocation)
		source_id = 3
		strike_zone_overlay.set_cell(Global.pitchLocation, source_id, atlas_coord)
		
		baseball_appears()
		
