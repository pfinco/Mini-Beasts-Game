extends Node2D

export var width : int
export var height : int
export var numBattlers : int

onready var tilePre = preload("res://Scenes/Tile.tscn")
onready var battlerPre = preload("res://Scenes/Battler.tscn")
onready var nameTagPre = preload("res://Scenes/NameTag.tscn")
onready var turnQueue = $TurnQueue
onready var nameTags = $NameTags

var map = []
var team1 = []
var team2 = []

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
			newTile.position = Vector2(x * TestMap.TILE_SIZE, y * TestMap.TILE_SIZE)
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
		
		newBattler.map = map
		newBattler.gridPosition = Vector2((i + 1) * 2, (i + 1) * 2)
		newBattler.position = Vector2((i + 1) * 2 * TestMap.TILE_SIZE, (i + 1) * 2 * TestMap.TILE_SIZE)
		
		map[(i + 1) * 2][(i + 1) * 2].battler = newBattler
		turnQueue.add_child(newBattler)
		newBattler.team = 1
		team1.append(newBattler)
		var tag = nameTagPre.instance()
		nameTags.add_child(tag)
		newBattler.nameTag = tag
		tag.changeName(newBattler.battlerName)
		tag.changeHealth(newBattler.hp, newBattler.maxHp)
		tag.set_global_position(Vector2(352 * i, 0))
	
	for i in range(numBattlers):
		var newBattler = battlerPre.instance()
		
		newBattler.map = map
		newBattler.gridPosition = Vector2(13 - ((i + 1) * 2), (i + 1) * 2)
		newBattler.position = Vector2((13 - ((i + 1) * 2)) * TestMap.TILE_SIZE, (i + 1) * 2 * TestMap.TILE_SIZE)
		
		map[13 - ((i + 1) * 2)][(i + 1) * 2].battler = newBattler
		turnQueue.add_child(newBattler)
		newBattler.team = 2
		team2.append(newBattler)
		var tag = nameTagPre.instance()
		nameTags.add_child(tag)
		newBattler.nameTag = tag
		tag.changeName(newBattler.battlerName)
		tag.changeHealth(newBattler.hp, newBattler.maxHp)
		tag.set_global_position(Vector2(1600 - (352 * i), 0))
