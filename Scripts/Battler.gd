extends Position2D

onready var tileSelector = $TileSelector
onready var attackSelector = $AttackSelector
onready var animator = $AnimationPlayer

export var stats : Resource

var maxHp
var hp
var atk
var def
var mob
var rAtk
var rDef

var battlerName = "Babaa"

var type1 = TestMap.battlerTypes.plain
var type2

var map
var gridPosition = Vector2.ZERO
var nameTag

func _ready():
	maxHp = stats.hp
	hp = maxHp
	atk = stats.atk
	def = stats.def
	mob = stats.mob
	rAtk = stats.rAtk
	rDef = stats.rDef
	
	animator.play("Idle")
	attackSelector.anim.play("Inactive")

func move():
	position += tileSelector.position
	tileSelector.position = Vector2.ZERO
	tileSelector.visible = false
	
	map[gridPosition.x][gridPosition.y].battler = null
	gridPosition = position / TestMap.TILE_SIZE
	map[gridPosition.x][gridPosition.y].battler = self
	attackSelector.anim.play("Active")

func valid_destination():
	var destination = gridPosition + (tileSelector.position / TestMap.TILE_SIZE)
	var distance = abs((destination.x - gridPosition.x)) + abs(destination.y - gridPosition.y)
	if distance <= mob && map[destination.x][destination.y].battler == null:
		return true
	else:
		return false

func target_at_destination():
	var destination = gridPosition + (attackSelector.position / TestMap.TILE_SIZE)
	if map[destination.x][destination.y].battler != null && map[destination.x][destination.y].battler != self:
		return true
	else:
		 return false

func attack_target():
	var destination = gridPosition + (attackSelector.position / TestMap.TILE_SIZE)
	attackSelector.position = Vector2.ZERO
	attackSelector.visible = false
	if map[destination.x][destination.y].battler != null:
		map[destination.x][destination.y].battler.receive_attack(atk)
		attackSelector.anim.play("Inactive")
		return true
	else:
		 return false

func receive_attack(damage):
	animator.play("Damage")
	hp -= damage
	if (hp <= 0):
		hp = 0
		die()
	nameTag.changeHealth(hp, maxHp)

func die():
	animator.play("Death")
