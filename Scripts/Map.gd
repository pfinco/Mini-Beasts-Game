extends Node2D

export var width : int
export var height : int
export var numBattlers : int

onready var tilePre = preload("res://Scenes/Tile.tscn")
onready var nameTagPre = preload("res://Scenes/NameTag.tscn")
onready var turnQueue = $TurnQueue
onready var nameTags = $NameTags

var map = []
var team1 = []
var team2 = []

var formation = [Vector2(4, 1), Vector2(4, 3), Vector2(4, 5), Vector2(9, 1), Vector2(9, 3), Vector2(9, 5)]

func _ready():
	create_map()
	var index = 0
	for b in Game.party:
		add_battler(b, team1, index)
		index += 1
	for b in Game.foes:
		add_battler(b, team2, index)
		index += 1
	turnQueue.start(self)

# Creates a new map
func create_map():
	for x in range(width):
		map.append([])
		map[x].resize(height)
		for y in range(height):
			var newTile = tilePre.instance()
			newTile.position = Vector2(x * Game.TILE_SIZE, y * Game.TILE_SIZE)
			add_child(newTile)
			map[x][y] = newTile
			randomize()
			if randi() % 5 == 1:
				newTile.convertTile(Game.terrainTypes.lush)
			if randi() % 15 == 1:
				newTile.convertTile(Game.terrainTypes.water)

# Adds a battler to the map
func add_battler(battler, team, index):

		var newBattler = battler.instance()
		# Places the battler on the map at the next location in the battle formation
		newBattler.map = map
		newBattler.gridPosition = formation[index]
		newBattler.position = formation[index] * Game.TILE_SIZE
		map[formation[index].x][formation[index].y].battler = newBattler
		# Adds the battler to the turn queue
		turnQueue.add_child(newBattler)
		# Creates a name tag and health bar for the battler
		var tag = nameTagPre.instance()
		nameTags.add_child(tag)
		newBattler.nameTag = tag
		tag.changeName(newBattler.battlerName)
		tag.changeHealth(newBattler.hp, newBattler.maxHp)
		# Assigns the battler to the given team
		team.append(newBattler)
		if team == team1:
			newBattler.team = 1
			tag.set_global_position(Vector2(275 * (team.size() - 1), 0))
		else:
			newBattler.team = 2
			tag.set_global_position(Vector2(1600 - (275 * (team.size() - 1)), 0))
