extends Position2D

onready var selector = $TileSelector

var maxHp = 100
var hp = maxHp
var atk = 40
var def = 30
var mob = 3
var rAtk = 10
var rDef = 10

var battlerName = "Babaa"

var type1 = TestMap.battlerTypes.plain
var type2

var gridPosition = Vector2.ZERO
