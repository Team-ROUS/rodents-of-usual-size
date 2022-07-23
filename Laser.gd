tool
extends Node

const SERCOMM = preload("res://addons/GDSerCommDock/bin/GDSerComm.gdns")
var PORT

onready var com = $Com

func plugin_installed():
	var directory = Directory.new();
	return directory.file_exists("res://addons/GDSerCommDock/bin/libGDSercomm.dylib")

func _ready():
	if plugin_installed():
		PORT = SERCOMM.new()
		PORT.open(
			"/dev/cu.usbserial-120",
			9600,
			1000,
			com.bytesz.SER_BYTESZ_8, 
			com.parity.SER_PAR_NONE, 
			com.stopbyte.SER_STOPB_ONE)
		PORT.flush()

var maps = [
	"6,0,RRRRRRRRRRRUUURRRR",
	"0,2,RRRRRUUUUURRRRRUUURRR",
	"11,0,RRRRRRDDDLLLDDDDRRRRRRUUUUURRRDDDDDDDDD",
	"14,0,RDDRRUURRRRRRDLDLULLDDDRRRRRURRDDDLLDLLULULLLDDRRDDLLLUUULDDDDDLUUUUULDDDDDDDRRRRRUURRDDRRRRRUUULLL",
	"0,0,RUURDRRUUUULUUURRDRUULLLLLUUURRDRUUURDDDDRRDDDRDDDDRURDDRUURUUUURUUULLLDLDRRDLLLUUUUURRRRDRR",
]
var map_idx = 0

func laser_set_map():
	if plugin_installed():
		PORT.write(maps[map_idx])
		PORT.flush()

func laser_change_map():
	map_idx += 1
	if map_idx >= len(maps):
		map_idx = 0
	laser_set_map()
