tool
extends Node

const SERCOMM = preload("res://addons/GDSerCommDock/bin/GDSerComm.gdns")
var PORT

onready var com = $Com

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
		print("pos:")
		print(pos)
