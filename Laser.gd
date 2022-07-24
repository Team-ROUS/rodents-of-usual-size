tool
extends Node

const SERCOMM = preload("res://addons/GDSerCommDock/bin/GDSerComm.gdns")
var PORT

onready var com = $Com

var maze_measurements = {
	"maze_2": {
		"1": pipe_bottom_adjustment([[2, 0],[110, 700]]),
		"2": pipe_bottom_adjustment([[14, 8],[708, 317]])
	},
	"maze_5": {
		"1": pipe_bottom_adjustment([[0, 0], [24, 702]]),
		"2": pipe_bottom_adjustment([[14, 12], [695, 126]])
	}
}
var params


func pipe_bottom_adjustment(mapping):
	# account for mouse sitting at the bottom of the pipe
	return [
		[mapping[0][0], mapping[0][1]],
		[mapping[1][0], mapping[1][1] + 0],
	]

func get_params(mapping_1, mapping_2):
	var dx_excel = mapping_2[0][0] - mapping_1[0][0]
	var dx_godot = mapping_2[1][0] - mapping_1[1][0]

	var dy_excel = mapping_2[0][1] - mapping_1[0][1]
	var dy_godot = mapping_2[1][1] - mapping_1[1][1]

	var godot_x_multiplier = dx_godot/dx_excel
	var godot_y_multiplier = dy_godot/dy_excel

	var godot_x1_simulated = godot_x_multiplier * mapping_1[0][0]
	var godot_y1_simulated = godot_y_multiplier * mapping_1[0][1]

	var godot_x1_diversion = godot_x1_simulated - mapping_1[1][0]
	var godot_y1_diversion = godot_y1_simulated - mapping_1[1][1]

	return {
		"x_multiplier": godot_x_multiplier,
		"y_multiplier": godot_y_multiplier,
		"x_constant": -godot_x1_diversion,
		"y_constant": -godot_y1_diversion
	}

func convert_x_from_excel(x, x_multiplier, x_constant):
	return x_multiplier * x + x_constant

func convert_y_from_excel(y, y_multiplier, y_constant):
	return y_multiplier * y + y_constant

func convert_x_from_godot(x, x_multiplier, x_constant):
	return (x - x_constant) / x_multiplier

func convert_y_from_godot(y, y_multiplier, y_constant):
	return (y - y_constant) / y_multiplier


func generate_route_progresses(map_idx, x, y):
	var y_current = y_start[map_idx]
	var x_current = x_start[map_idx]
	var map = maps[map_idx]
	var progresses = []
	for i in len(map):
		pass
		progresses.append([
			i, 
			[x_current, y_current],
			[x, y]
		])
		var dir = map[i]
		if dir == 'u':
			y_current += 1
		if dir == 'd':
			y_current -= 1
		if dir == 'l':
			x_current -= 1
		if dir == 'r':
			x_current += 1
	return progresses

func find_closest_progress(map_idx, x, y):
	var progresses = generate_route_progresses(map_idx, x, y)
	progresses.sort_custom(self, "dist_comparison")
	return progresses[0]
	
func get_progress_dist(a):
	var dx_a = a[1][0] - a[2][0]
	var dy_a = a[1][1] - a[2][1]
	return sqrt(pow(dx_a, 2) + pow(dy_a, 2)) 
	
func dist_comparison(a, b):
	var dist_a = get_progress_dist(a)
	var dist_b = get_progress_dist(b)
	if dist_a < dist_b:
		return true
	else:
		return false


# WARNING: this has to be the same as in Arduino repo
var x_start = [0, 2, 0, 0, 0];
var y_start = [6, 0, 12, 14, 0];
var maps = [
	"rrrrrrrrrrruuurrrr",
	"rrrrruuuuurrrrruuurrr",
	"rrrrrrdddlllddddrrrrrruuuuurrrddddddddd",
	"rddrruurrrrrrdldlulldddrrrrrurrdddlldllululllddrrddllluuuldddddluuuuuldddddddrrrrruurrddrrrrruuulll",
	"ruurdrruuuuluuurrdruullllluuurrdruuurddddrrdddrddddrurddruuruuuuruuullldldrrdllluuuuurrrrdrr",
]

var last_change = OS.get_ticks_msec()

func get_map_idx():
	var name = get_tree().get_current_scene().get_name()
	if name == "Maze1":
		return 0
	elif name == "Maze2":
		return 1
	elif name == "Maze3":
		return 2
	elif name == "Maze4":
		return 3
	elif name == "Maze5":
		return 4
	

func plugin_installed():
	var directory = Directory.new();
	return directory.file_exists("res://addons/GDSerCommDock/bin/libGDSercomm.dylib")

func _ready():
	
#	print(generate_route_progresses(1,0,0))
	
	if plugin_installed():
		PORT = SERCOMM.new()
		PORT.open(
			"/dev/cu.usbserial-0001",
			9600,
			1000,
			com.bytesz.SER_BYTESZ_8, 
			com.parity.SER_PAR_NONE, 
			com.stopbyte.SER_STOPB_ONE)
		PORT.flush()
		laser_update()

func laser_set_map(map_idx, player_progress):
	if plugin_installed():
		var tmp = "%d,%d\n" % [map_idx, player_progress]
		PORT.write(tmp)
		PORT.flush()

func laser_update():
	if OS.get_ticks_msec() - last_change > 150:
		var map_idx = get_map_idx()
		
		last_change = OS.get_ticks_msec()
		var pos = get_node("/root/Maze%d/player" % [map_idx+1]).get_position()
		var measurements = maze_measurements["maze_%d" % [map_idx+1]]
		var params = get_params(measurements["1"], measurements["2"])
		var x = convert_x_from_godot(pos[0], params["x_multiplier"], params["x_constant"])
		var y = convert_y_from_godot(pos[1], params["y_multiplier"], params["y_constant"])
		print("pos: (%d, %d) (%d, %d)" % [x, y, pos[0], pos[1]])

		var closest_progress = find_closest_progress(map_idx, x, y)
		var dist = get_progress_dist(closest_progress)
		# print(dist,closest_progress)
		laser_set_map(map_idx, closest_progress[0] if dist < 1.2 else 255)
