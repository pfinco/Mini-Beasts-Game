extends Node2D

const TILE_SIZE = 128

var party = []

var foes = []

var battlerTypes = {
	"plain" : 0,
	"plant" : 1,
	"water" : 2,
	"snow" : 3,
	"sand" : 4,
	"rock" : 5,
	"fire" : 6,
	"poison" : 7,
	"electric" : 8,
	"metal" : 9,
	"magic" : 10,
	"space" : 11,
	"air" : 12,
	"ground" : 13,
	"light" : 14,
	"ghost" : 15,
	"sound" : 16
}

var terrainTypes = {
	"plain" : 0,
	"lush" : 1,
	"water" : 2,
	"snow" : 3,
	"sand" : 4,
	"rocks" : 5,
	"scorched" : 6,
	"foul" : 7,
	"charged" : 8,
	"metal" : 9,
	"enchanted" : 10,
	"warped" : 11
}

func _process(_delta):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
