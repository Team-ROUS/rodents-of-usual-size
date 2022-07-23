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
var map_idx = 0
var player_progress = 0
var last_change = OS.get_ticks_msec()

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

func laser_set_map():
	if plugin_installed():
		var tmp = "%d,%d\n" % [map_idx, player_progress]
		PORT.write(tmp)
		PORT.flush()

func laser_update():
	if OS.get_ticks_msec() - last_change > 150:
		player_progress += 1
		if player_progress >= len(maps[map_idx]):
			player_progress = 0
		laser_set_map()
		last_change = OS.get_ticks_msec()
