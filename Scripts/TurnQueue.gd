extends Node2D

var map
var activeBattler
var phase
var menu
var chosenAction
var roundsPassed = 0

onready var gameOverPre = preload("res://Scenes/BattleEndPlaceholder.tscn")
onready var actionMenuPre = preload("res://Scenes/ActionMenu.tscn")

var phases = {
	"none" : 0,
	"move" : 1,
	"action" : 2,
	"end" : 3
}

# Initializes the turn queue
func start(newMap):
	map = newMap
	activeBattler = get_child(0)
	phase = phases.move

func _process(_delta):
	# Ends the battle if one of the teams has no remaining battlers
	if is_team_defeated(map.team1) || is_team_defeated(map.team2) && phase != phases.end:
		phase = phases.end
		var go = gameOverPre.instance()
		map.add_child(go)
		go.set_global_position(Vector2.ZERO)

# Changes the active battler
func change_turn():
	activeBattler.turnsTaken += 1
	if end_of_round():
		roundsPassed += 1
	activeBattler = get_next_battler()
	phase = phases.move
	if activeBattler.defeated():
		change_turn()

# Gets the next logical, unacted battler in order of mobility
func get_next_battler():
	var next_battler = get_unacted_battler()
	for battler in get_children():
		if battler.mob > next_battler.mob && battler.turnsTaken <= roundsPassed:
			next_battler = battler;
	return next_battler

# Gets a battler that has not acted this round
func get_unacted_battler():
	for battler in get_children():
		if battler.turnsTaken <= roundsPassed:
			return battler
	push_error("No unacted battlers found, undealt with error")

# Checks whether or not a round has passed
func end_of_round():
	var checker = get_child((activeBattler.get_index() + 1) % get_child_count()) 
	for battler in get_children():
		if checker.turnsTaken != battler.turnsTaken:
			return false
	return true

# Pulls up the attack menu for a battler
func start_attack_phase():
	phase = phases.action
	var actionMenu = actionMenuPre.instance()
	activeBattler.add_child(actionMenu)
	actionMenu.populateList(activeBattler.moveList)
	menu = actionMenu

func _input(event):
	match phase:
		phases.move:
			# Moves battler to the current selected tile if possible
			if event.is_action_pressed("ui_accept") && activeBattler.valid_destination():
				activeBattler.move()
				start_attack_phase()
			# Moves the selector
			else:
				move_selector(event, activeBattler.tileSelector)
				if activeBattler.valid_destination():
					activeBattler.tileSelector.anim.play("Valid")
				else:
					activeBattler.tileSelector.anim.play("Invalid")
		phases.action:
			if event.is_action_pressed("ui_accept"):
				if chosenAction == null:
					# Pass turn if the last menu option is chosen
					if menu.selectedAction == menu.get_child_count() - 1:
						change_turn()
						menu.queue_free()
					else:
						# Mark the tiles in the attack range of the chosen attack
						activeBattler.facing = Vector2(1, 1)
						chosenAction = activeBattler.moveList[menu.selectedAction]
						activeBattler.mark_targets(chosenAction)
						menu.queue_free()
				elif activeBattler.has_valid_targets(chosenAction):
					# Attack the chosen target in range and change turns
					activeBattler.attack_targets(chosenAction)
					if activeBattler.targetSelector != null:
						var selec = activeBattler.targetSelector
						activeBattler.remove_child(selec)
						selec.free()
						activeBattler.targetSelector = null
					chosenAction = null
					change_turn()
			
			# Change the direction a battler is facing
			elif event.is_action_pressed("ui_left"):
				if chosenAction != null:
					if activeBattler.targetSelector == null:
						activeBattler.facing = Vector2(-1, 1)
						activeBattler.mark_targets(chosenAction)
					else:
						move_selector(event, activeBattler.targetSelector)
			elif event.is_action_pressed("ui_right"):
				if chosenAction != null:
					if activeBattler.targetSelector == null:
						activeBattler.facing = Vector2(1, 1)
						activeBattler.mark_targets(chosenAction)
					else:
						move_selector(event, activeBattler.targetSelector)
			
			# Navigate the attack menu
			elif event.is_action_pressed("ui_down"):
				if chosenAction != null && activeBattler.targetSelector != null:
					move_selector(event, activeBattler.targetSelector)
			elif event.is_action_pressed("ui_up"):
				if chosenAction != null && activeBattler.targetSelector != null:
					move_selector(event, activeBattler.targetSelector)
			
			# Return to previous menu
			elif event.is_action_pressed("ui_back"):
				if chosenAction != null:
					start_attack_phase()
					activeBattler.remove_selectors()
					if activeBattler.targetSelector != null:
						var selec = activeBattler.targetSelector
						activeBattler.remove_child(selec)
						selec.free()
						activeBattler.targetSelector = null
					chosenAction = null

# Move the tile selector of a battler
func move_selector(event, selector):
	if (event.is_action_pressed("ui_left") && selector.get_position().x > 0):
		selector.move(Vector2(-1, 0))
	elif (event.is_action_pressed("ui_right") && selector.get_position().x < (map.width - 1 ) * 128):
		selector.move(Vector2(1, 0))
	elif (event.is_action_pressed("ui_up") && selector.get_position().y > 0):
		selector.move(Vector2(0, -1))
	elif (event.is_action_pressed("ui_down") && selector.get_position().y < (map.height - 1) * 128):
		selector.move(Vector2(0, 1))

# Checks if a team has any remaining battlers
func is_team_defeated(team):
	for battler in team:
		if battler.defeated() == false:
			return false
	return true
