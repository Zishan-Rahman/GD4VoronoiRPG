extends TileMap

var x_tile_range: int = ProjectSettings.get_setting("display/window/size/viewport_width") / tile_set.tile_size.x
var y_tile_range: int = ProjectSettings.get_setting("display/window/size/viewport_height") / tile_set.tile_size.y

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	for x in range(-50, x_tile_range + 50):
		for y in range(-50, y_tile_range + 50):
			set_cell(0, Vector2(x, y), 0, Vector2(0, 0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
