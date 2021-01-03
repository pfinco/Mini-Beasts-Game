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
var turnsTaken = 0

var type1 = Game.battlerTypes.plain
var type2 = Game.battlerTypes.plain

var map
var gridPosition = Vector2.ZERO
var facing = Vector2(1, 1)
var nameTag
var targetSelector = null

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

# Moves the battler to the selected tile
func move():
	position += tileSelector.position
	tileSelector.position = Vector2.ZERO
	tileSelector.visible = false
	
	map[gridPosition.x][gridPosition.y].battler = null
	gridPosition = position / Game.TILE_SIZE
	map[gridPosition.x][gridPosition.y].battler = self

# Checks if the battler is allowed to move to the selected tile
func valid_destination():
	var destination = gridPosition + (tileSelector.position / Game.TILE_SIZE)
	var distance = abs((destination.x - gridPosition.x)) + abs(destination.y - gridPosition.y)
	if distance <= mob && map[destination.x][destination.y].battler == null || distance <= mob && map[destination.x][destination.y].battler == self || distance <= mob && map[destination.x][destination.y].battler.defeated():
		return true
	else:
		return false

# Checks if there are valid targets in the given action's attack range
func has_valid_targets(action):
	if action.numTargets == "One":
		var destination = targetSelector.get_position() / Game.TILE_SIZE
		if destination.x >= 0 && destination.x < map.size() && destination.y >= 0 && destination.y < map[0].size() && destination - gridPosition in action.targetedTiles:
				if map[destination.x][destination.y].battler != null && check_relation(map[destination.x][destination.y].battler) in action.targetTypes && map[destination.x][destination.y].battler.defeated() == false:
					return true
	else:
		for tile in action.targetedTiles:
			var destination = gridPosition + (tile * facing)
			if destination.x >= 0 && destination.x < map.size() && destination.y >= 0 && destination.y < map[0].size():
				if map[destination.x][destination.y].battler != null && check_relation(map[destination.x][destination.y].battler) in action.targetTypes && map[destination.x][destination.y].battler.defeated() == false:
					return true
	return false

# Visualizes the attack range of the given action on the map
func mark_targets(action):
	remove_selectors()
	if action.numTargets == "One":
		for tile in action.targetedTiles:
			var destination = gridPosition + (tile * facing)
			if destination.x >= 0 && destination.x < map.size() && destination.y >= 0 && destination.y < map[0].size():
				var selector = attackSelector.instance()
				$AttackSelectors.add_child(selector)
				selector.set_position(tile * facing * Game.TILE_SIZE)
		var selector = attackSelector.instance()
		targetSelector = selector
		add_child(selector)
		selector.anim.play("Valid")
		selector.set_position(action.targetedTiles[0] * facing * Game.TILE_SIZE)
	else:
		for tile in action.targetedTiles:
			var destination = gridPosition + (tile * facing)
			if destination.x >= 0 && destination.x < map.size() && destination.y >= 0 && destination.y < map[0].size():
				var selector = attackSelector.instance()
				$AttackSelectors.add_child(selector)
				selector.set_position(tile * facing * Game.TILE_SIZE)

# Uses the given action's effect on the targets in the action's attack range
func attack_targets(action):
	if action.numTargets == "All":
		# Affects all targets in range
		for tile in action.targetedTiles:
			var destination = gridPosition + (tile * facing)
			if destination.x >= 0 && destination.x < map.size() && destination.y >= 0 && destination.y < map[0].size():
				if map[destination.x][destination.y].battler != null && check_relation(map[destination.x][destination.y].battler) in action.targetTypes && map[destination.x][destination.y].battler.defeated() == false:
					attack(map[destination.x][destination.y].battler, action)
					if action.kbPower != 0:
						deal_knockback(map[destination.x][destination.y].battler, action)
	elif action.numTargets == "First":
		# Affects the first found valid target in range
		for tile in action.targetedTiles:
			var destination = gridPosition + (tile * facing)
			if destination.x >= 0 && destination.x < map.size() && destination.y >= 0 && destination.y < map[0].size():
				if map[destination.x][destination.y].battler != null && check_relation(map[destination.x][destination.y].battler) in action.targetTypes && map[destination.x][destination.y].battler.defeated() == false:
					attack(map[destination.x][destination.y].battler, action)
					if action.kbPower != 0:
						deal_knockback(map[destination.x][destination.y].battler, action)
					break
	elif action.numTargets == "One":
		# Affects the target at the position of the selector
		var destination = targetSelector.get_position() / Game.TILE_SIZE
		if destination.x >= 0 && destination.x < map.size() && destination.y >= 0 && destination.y < map[0].size():
			if map[destination.x][destination.y].battler != null && check_relation(map[destination.x][destination.y].battler) in action.targetTypes && map[destination.x][destination.y].battler.defeated() == false:
				attack(map[destination.x][destination.y].battler, action)
				if action.kbPower != 0:
					deal_knockback(map[destination.x][destination.y].battler, action)
	remove_selectors()

# Remove all target selectors for this battler from the map
func remove_selectors():
	for selector in $AttackSelectors.get_children():
		$AttackSelectors.remove_child(selector)
		selector.queue_free()

# Deal the given amount of damage to this battler
func take_damage(amount):
	animator.play("Damage")
	hp -= amount
	if hp <= 0:
		hp = 0
		die()
	nameTag.changeHealth(hp, maxHp)

# Recover the given amount of health to this battler
func heal(amount):
	animator.play("Heal")
	hp += amount
	if hp >= maxHp:
		hp = maxHp
	nameTag.changeHealth(hp, maxHp)

# Uses the given action on the given target
func attack(target, action):
	var damage
	if action.category == "Melee":
		if target.def < 1:
			target.def = 1
		damage = (action.power * atk) / target.def
		target.take_damage(damage)
	elif action.category == "Ranged":
		if target.rDef < 1:
			target.rDef = 1
		damage = (action.power * rAtk) / target.rDef
		target.take_damage(damage)
	elif action.category == "Healing":
		damage = target.maxHp / action.power
		target.heal(damage)

# Moves the given target according to the knockback values of the given action
func deal_knockback(target, action):
	for _i in range(action.kbPower):
		if map[target.gridPosition.x + action.kbDirection.x * facing.x][target.gridPosition.y + action.kbDirection.y * facing.y].battler == null:
			target.position += action.kbDirection * facing * Game.TILE_SIZE
			map[target.gridPosition.x][target.gridPosition.y].battler = null
			target.gridPosition = target.position / Game.TILE_SIZE
			map[target.gridPosition.x][target.gridPosition.y].battler = target
		else:
			attack(map[target.gridPosition.x + action.kbDirection.x * facing.x][target.gridPosition.y + action.kbDirection.y * facing.y].battler, action)
			attack(target, action)
			break

# Checks the relationship between this battler and the given battler
func check_relation(battler):
	if battler == self:
		return "Self"
	elif battler.team == team:
		return "Ally"
	else :
		return "Foe"

# Kills the battler
func die():
	animator.play("Death")

# Checks if this battler is currently defeated
func defeated():
	if hp <= 0:
		return true
	else:
		return false
