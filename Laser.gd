tool
extends Node

const SERCOMM = preload("res://addons/GDSerCommDock/bin/GDSerComm.gdns")
var PORT

onready var com = $Com

var maze_2_mapping_1 = pipe_bottom_adjustment([
	[2, 0],
	[111.2752, 702.925232],
])

var maze_2_mapping_2 = pipe_bottom_adjustment([
	[14, 8],
	[707.144226, 318.925262], 
])

func pipe_bottom_adjustment(mapping):
	# account for mouse sitting at the bottom of the pipe
	return [
		[mapping[0][0], mapping[0][1]],
		[mapping[1][0], mapping[1][1] + 25],
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


var params = get_params(maze_2_mapping_1, maze_2_mapping_2)

func convert_x_from_excel(x, x_multiplier, x_constant):
	return x_multiplier * x + x_constant

func convert_y_from_excel(y, y_multiplier, y_constant):
	return y_multiplier * y + y_constant

func convert_x_from_godot(x, x_multiplier, x_constant):
	return (x - x_constant) / x_multiplier

func convert_y_from_godot(y, y_multiplier, y_constant):
	return (y - y_constant) / y_multiplier


var maps = [
	"6,0,RRRRRRRRRRRUUURRRR",
	"0,2,RRRRRUUUUURRRRRUUURRR",
	"11,0,RRRRRRDDDLLLDDDDRRRRRRUUUUURRRDDDDDDDDD",
	"14,0,RDDRRUURRRRRRDLDLULLDDDRRRRRURRDDDLLDLLULULLLDDRRDDLLLUUULDDDDDLUUUUULDDDDDDDRRRRRUURRDDRRRRRUUULLL",
	"0,0,RUURDRRUUUULUUURRDRUULLLLLUUURRDRUUURDDDDRRDDDRDDDDRURDDRUURUUUURUUULLLDLDRRDLLLUUUUURRRRDRR",
]
var player_progress = 0
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

func laser_set_map(map_idx):
	if plugin_installed():
		var tmp = "%d,%d\n" % [map_idx, player_progress]
		PORT.write(tmp)
		PORT.flush()

func laser_update():
	if OS.get_ticks_msec() - last_change > 150:
		var map_idx = get_map_idx()
		player_progress += 1
		if player_progress >= len(maps[map_idx]):
			player_progress = 0
		laser_set_map(map_idx)
		last_change = OS.get_ticks_msec()
		var pos = get_node("/root/Maze%d/player" % [map_idx+1]).get_position()
		var x = convert_x_from_godot(pos[0], params["x_multiplier"], params["x_constant"])
		var y = convert_y_from_godot(pos[1], params["y_multiplier"], params["y_constant"])
		print("pos: %d, %d" % [x, y])
