extends Node2D

var map
var activeBattler
var phase

onready var gameOverPre = preload("res://Scenes/BattleEndPlaceholder.tscn")

var phases = {
	"none" : 0,
	"move" : 1,
	"action" : 2,
	"end" : 3
}

func start(newMap):
	map = newMap
	activeBattler = get_child(0)
	phase = phases.move

func _process(delta):
	if is_team_defeated(map.team1) || is_team_defeated(map.team2) && phase != phases.end:
		phase = phases.end
		var go = gameOverPre.instance()
		map.add_child(go)
		go.set_global_position(Vector2.ZERO)

func change_turn():
	var newIndex = (activeBattler.get_index() + 1) % get_child_count()
	activeBattler = get_child(newIndex)
	phase = phases.move
	if activeBattler.defeated():
		change_turn()

func start_attack_phase():
	phase = phases.action

func _input(event):
	match phase:
		phases.move:
			if event.is_action_pressed("ui_accept") && activeBattler.valid_destination():
				activeBattler.move()
				start_attack_phase()
			else:
				move_selector(event, activeBattler.tileSelector)
				if activeBattler.valid_destination():
					activeBattler.tileSelector.anim.play("Valid")
				else:
					activeBattler.tileSelector.anim.play("Invalid")
		phases.action:
			if event.is_action_pressed("ui_accept") && activeBattler.target_at_destination():
				activeBattler.attack_target()
				change_turn()
			else:
				move_selector(event, activeBattler.attackSelector)

func move_selector(event, selector):
	if (event.is_action_pressed("ui_left") && selector.get_position().x > 0):
		selector.move(Vector2(-1, 0))
	elif (event.is_action_pressed("ui_right") && selector.get_position().x < (map.width - 1 ) * 128):
		selector.move(Vector2(1, 0))
	elif (event.is_action_pressed("ui_up") && selector.get_position().y > 0):
		selector.move(Vector2(0, -1))
	elif (event.is_action_pressed("ui_down") && selector.get_position().y < (map.height - 1) * 128):
		selector.move(Vector2(0, 1))

func is_team_defeated(team):
	for battler in team:
		if battler.defeated() == false:
			return false
	return true
