extends TileMap

var points: Array[Dictionary] = []
const EUCLIDEAN: String = "Euclidean distance"
const MANHATTAN: String = "Manhattan distance"
@export_enum(EUCLIDEAN, MANHATTAN) var distance: String = MANHATTAN
@export_range(2, 6, 1) var random_starting_points: int = 4
var x_tile_range: int = ProjectSettings.get_setting("display/window/size/viewport_width") / tile_set.tile_size.x
var y_tile_range: int = ProjectSettings.get_setting("display/window/size/viewport_height") / tile_set.tile_size.y

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	for x in range(-50, x_tile_range + 50):
		for y in range(-50, y_tile_range + 50):
			set_cell(0, Vector2(x, y), 0, Vector2(0, 0))
	var start_time: float = Time.get_ticks_msec()
	define_points(random_starting_points)
	paint_points()
	var new_time: float = Time.get_ticks_msec() - start_time
	print("Time taken: " + str(new_time) + "ms")

func paint_points() -> void:
	for point in points:
		set_cell(0, Vector2(point["x"], point["y"]), 0, point["type"])
		for citizen in point["citizens"]:
			set_cell(0, Vector2(point["x"] + citizen["dx"], point["y"] + citizen["dy"]), 0, point["type"])

func _squared(x: int) -> int:
	return x ** 2

func calculate_points_delta(x: int, y: int, p: int) -> float:
	if distance == MANHATTAN:
		return abs(points[p]["x"] - x) + abs(points[p]["y"] - y)
	return sqrt(_squared(points[p]["x"] - x) + _squared(points[p]["y"] - y))

func define_points(num_points: int) -> void:
	var types: Array[Vector2i] = [Vector2i(0,1),Vector2i(1,1),Vector2i(2,1),Vector2i(5,1),Vector2i(6,1),Vector2i(4,2)]
	for i in range(num_points):
		var x: int = randi_range(0, x_tile_range)
		var y: int = randi_range(0, y_tile_range)
		var type: Vector2i = types.pick_random()
		types.erase(type)
		points.append(
			{
				"type": type,
				"x": x,
				"y": y,
				"citizens": []
			}
		)
	for x in range(x_tile_range):
		for y in range(y_tile_range):
			var lowest_delta: Dictionary = {
				"point_id": 0,
				"delta": x_tile_range * y_tile_range
			}
			for p in range(len(points)):
				var delta: float = calculate_points_delta(x, y, p)
				if delta < lowest_delta["delta"]:
					lowest_delta = {
						"point_id": p,
						"delta": delta
					}
				var active_point: Dictionary = points[lowest_delta["point_id"]]
				var dx: int = x - active_point["x"]
				var dy: int = y - active_point["y"]
				active_point["citizens"].append(
					{
						"dx": dx,
						"dy": dy
					}
				)
