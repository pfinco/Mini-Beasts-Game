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

var map
var gridPosition = Vector2.ZERO

func move():
	position += selector.position
	selector.position = Vector2.ZERO
	selector.visible = false
	
	map[gridPosition.x][gridPosition.y].battler = null
	gridPosition = position / TestMap.TILE_SIZE
	map[gridPosition.x][gridPosition.y].battler = self

func destination_free():
	var destination = gridPosition + (selector.position / TestMap.TILE_SIZE)
	if map[destination.x][destination.y].battler != null:
		return false
	else:
		 return true

func target_at_destination():
	var destination = gridPosition + (selector.position / TestMap.TILE_SIZE)
	if map[destination.x][destination.y].battler != null:
		return true
	else:
		 return false

func attack_target():
	var destination = gridPosition + (selector.position / TestMap.TILE_SIZE)
	selector.position = Vector2.ZERO
	selector.visible = false
	if map[destination.x][destination.y].battler != null:
		map[destination.x][destination.y].battler.receive_attack(atk)
		return true
	else:
		 return false

func receive_attack(damage):
	hp -= damage
	if (hp <= 0):
		die()

func die():
	visible = false
