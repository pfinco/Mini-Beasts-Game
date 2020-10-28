extends Node2D

export var width : int
export var height : int
export var numBattlers : int

onready var tilePre = preload("res://Scenes/Tile.tscn")
onready var babaaPre = preload("res://Scenes/Mini Beasts/Babaa.tscn")
onready var stelluxePre = preload("res://Scenes/Mini Beasts/Stelluxe.tscn")
onready var sapackPre = preload("res://Scenes/Mini Beasts/Sapack.tscn")
onready var machirpPre = preload("res://Scenes/Mini Beasts/Machirp.tscn")
onready var nameTagPre = preload("res://Scenes/NameTag.tscn")
onready var turnQueue = $TurnQueue
onready var nameTags = $NameTags

var map = []
var team1 = []
var team2 = []

var formation = [Vector2(4, 2), Vector2(4, 4), Vector2(9, 2), Vector2(9, 4)]

func _ready():
	create_map()
	add_battler(babaaPre, team1, 0)
	add_battler(stelluxePre, team1, 1)
	add_battler(sapackPre, team2, 2)
	add_battler(machirpPre, team2, 3)
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

func add_battler(battler, team, index):

		var newBattler = battler.instance()
		
		newBattler.map = map
		newBattler.gridPosition = formation[index]
		newBattler.position = formation[index] * TestMap.TILE_SIZE

		map[formation[index].x][formation[index].y].battler = newBattler
		turnQueue.add_child(newBattler)
		var tag = nameTagPre.instance()
		nameTags.add_child(tag)
		newBattler.nameTag = tag
		tag.changeName(newBattler.battlerName)
		tag.changeHealth(newBattler.hp, newBattler.maxHp)
		team.append(newBattler)
		if team == team1:
			newBattler.team = 1
			tag.set_global_position(Vector2(352 * (team.size() - 1), 0))
		else:
			newBattler.team = 2
			tag.set_global_position(Vector2(1600 - (352 * (team.size() - 1)), 0))
