extends Position2D

onready var tileSelector = $TileSelector
onready var animator = $AnimationPlayer
onready var moveList = $MoveList.get_children()
onready var attackSelector = preload("res://Scenes/AttackSelector.tscn")

export var stats : Resource

var maxHp
var hp
var atk
var def
var mob
var rAtk
var rDef

var battlerName = "Babaa"
var team

var type1 = TestMap.battlerTypes.plain
var type2 = TestMap.battlerTypes.plain

var map
var gridPosition = Vector2.ZERO
var facing = Vector2(1, 1)
var nameTag

func _ready():
	battlerName = stats.name
	maxHp = stats.hp
	hp = maxHp
	atk = stats.atk
	def = stats.def
	mob = stats.mob
	rAtk = stats.rAtk
	rDef = stats.rDef
	
	animator.play("Idle")

func move():
	position += tileSelector.position
	tileSelector.position = Vector2.ZERO
	tileSelector.visible = false
	
	map[gridPosition.x][gridPosition.y].battler = null
	gridPosition = position / TestMap.TILE_SIZE
	map[gridPosition.x][gridPosition.y].battler = self

func valid_destination():
	var destination = gridPosition + (tileSelector.position / TestMap.TILE_SIZE)
	var distance = abs((destination.x - gridPosition.x)) + abs(destination.y - gridPosition.y)
	if distance <= mob && map[destination.x][destination.y].battler == null || distance <= mob && map[destination.x][destination.y].battler == self || distance <= mob && map[destination.x][destination.y].battler.defeated():
		return true
	else:
		return false

func has_valid_targets(action):
	for tile in action.targetedTiles:
		var destination = gridPosition + (tile * facing)
		if destination.x >= 0 && destination.x < map.size() && destination.y >= 0 && destination.y < map[0].size():
			if map[destination.x][destination.y].battler != null && check_relation(map[destination.x][destination.y].battler) == "Foe" && map[destination.x][destination.y].battler.defeated() == false:
				return true
	return false

func mark_targets(action):
	remove_selectors()
	for tile in action.targetedTiles:
		var destination = gridPosition + (tile * facing)
		if destination.x >= 0 && destination.x < map.size() && destination.y >= 0 && destination.y < map[0].size():
			var selector = attackSelector.instance()
			$AttackSelectors.add_child(selector)
			selector.set_position(tile * facing * TestMap.TILE_SIZE)

func attack_targets(action):
	for tile in action.targetedTiles:
		var destination = gridPosition + (tile * facing)
		if destination.x >= 0 && destination.x < map.size() && destination.y >= 0 && destination.y < map[0].size():
			if map[destination.x][destination.y].battler != null && check_relation(map[destination.x][destination.y].battler) == "Foe" && map[destination.x][destination.y].battler.defeated() == false:
				attack(map[destination.x][destination.y].battler, action)
				if action.kbPower != 0:
					deal_knockback(map[destination.x][destination.y].battler, action)
	remove_selectors()

func remove_selectors():
	for selector in $AttackSelectors.get_children():
		$AttackSelectors.remove_child(selector)
		selector.queue_free()

func take_damage(amount):
	animator.play("Damage")
	hp -= amount
	if (hp <= 0):
		hp = 0
		die()
	nameTag.changeHealth(hp, maxHp)

func attack(target, action):
	var damage
	if action.category == "Melee":
		if target.def < 1:
			target.def = 1
		damage = (action.power * atk) / target.def
	elif action.category == "Ranged":
		if target.rDef < 1:
			target.rDef = 1
		damage = (action.power * rAtk) / target.rDef
	target.take_damage(damage)

func deal_knockback(target, action):
	for i in range(action.kbPower):
		if map[target.gridPosition.x + action.kbDirection.x * facing.x][target.gridPosition.y + action.kbDirection.y * facing.y].battler == null:
			target.position += action.kbDirection * facing * TestMap.TILE_SIZE
			map[target.gridPosition.x][target.gridPosition.y].battler = null
			target.gridPosition = target.position / TestMap.TILE_SIZE
			map[target.gridPosition.x][target.gridPosition.y].battler = target
		else:
			attack(map[target.gridPosition.x + action.kbDirection.x * facing.x][target.gridPosition.y + action.kbDirection.y * facing.y].battler, action)
			attack(target, action)
			break

func check_relation(battler):
	if battler == self:
		return "Self"
	elif battler.team == team:
		return "Ally"
	else :
		return "Foe"

func die():
	animator.play("Death")

func defeated():
	if hp <= 0:
		return true
	else:
		return false
