extends Position2D

signal tileConverted(type)

var type
var prevType
var battler

func _ready():
	type =  Game.terrainTypes.plain

# Changes the type of the tile
func convertTile(newType):
	if type != newType:
		prevType = type
		type = newType
		emit_signal("tileConverted", newType)
