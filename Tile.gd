extends Position2D

signal tileConverted(type)

var type
var prevType

func _ready():
	type =  TestMap.types.plain

func convertTile(newType):
	if type != newType:
		prevType = type
		type = newType
		emit_signal("tileConverted", newType)
