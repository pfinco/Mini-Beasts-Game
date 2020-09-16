extends Node2D

export var width : int
export var height : int
export var numBattlers : int

onready var tilePre = preload("res://Tile.tscn")
onready var battlerPre = preload("res://Battler.tscn")
onready var turnQueue = $TurnQueue

var map = []

func _ready():
	create_map()
	create_battlers()
	turnQueue.start(self)

func create_map():
	for x in range(width):
		map.append([])
		map[x].resize(height)
		for y in range(height):
			var newTile = tilePre.instance()
			newTile.position = Vector2(x * 128, y * 128)
			add_child(newTile)
			map[x][y] = newTile
			randomize()
			if randi() % 5 == 1:
				newTile.convertTile(TestMap.terrainTypes.lush)
			if randi() % 15 == 1:
				newTile.convertTile(TestMap.terrainTypes.water)
	

func create_battlers():
	for i in range(numBattlers):
		var newBattler = battlerPre.instance()
		newBattler.position = Vector2(i * 256, i * 256)
		map[i][i].battler = newBattler
		turnQueue.add_child(newBattler)