extends Node2D

export var width : int
export var height : int

onready var tilePre = preload("res://Tile.tscn")
onready var battlers = $Battlers

var map = []

func _ready():
	
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
				newTile.convertTile(TestMap.types.lush)
			if randi() % 15 == 1:
				newTile.convertTile(TestMap.types.water)
	
	
