extends TileMapLayer

@onready var strike_zone: TileMapLayer = $"."
@onready var strike_zone_overlay: TileMapLayer = $"../StrikeZoneOverlay"
var previous_hovered_pos : Vector2i

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func get_cells_within_radius(center: Vector2i, radius: float) -> Array:
	var cells: Array = []

	var min = -ceil(radius)
	var max = ceil(radius)

	for x in range(min, max):
		for y in range(min, max):
			var offset = Vector2i(x, y)
			if offset.length() <= radius:
				cells.append(center + offset)

	return cells
	
func finalize_pitch_location(cells: Array):
	for cell in cells:
		var source_id = 2
		var atlas_coord = Vector2i(0,0)
		strike_zone.set_cell(cell, source_id, atlas_coord)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("click"):
		var mouse_pos: Vector2 = get_global_mouse_position()
		var center_cell: Vector2i = local_to_map(to_local(mouse_pos))
		var cells = get_cells_within_radius(center_cell, 6.2)
		finalize_pitch_location(cells)
		
