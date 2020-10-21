extends Node2D

var map
var activeBattler
var phase

var phases = {
	"none" : 0,
	"move" : 1,
	"attack" : 2,
	"delete_me_test" : 3
}

func start(newMap):
	map = newMap
	activeBattler = get_child(0)
	phase = phases.move

func change_turn():
	var newIndex = (activeBattler.get_index() + 1) % get_child_count()
	activeBattler = get_child(newIndex)

func _input(event):
	match phase:
		phases.move:
			if event.is_action_pressed("ui_accept") && activeBattler.destination_free():
				activeBattler.move()
				change_turn()
			elif event.is_action_pressed("ui_left") && activeBattler.selector.get_position().x > 0:
				activeBattler.selector.move(Vector2(-1, 0))
			elif event.is_action_pressed("ui_right") && activeBattler.selector.get_position().x < (map.width - 1 ) * 128:
				activeBattler.selector.move(Vector2(1, 0))
			elif event.is_action_pressed("ui_up") && activeBattler.selector.get_position().y > 0:
				activeBattler.selector.move(Vector2(0, -1))
			elif event.is_action_pressed("ui_down") && activeBattler.selector.get_position().y < (map.height - 1) * 128:
				activeBattler.selector.move(Vector2(0, 1))
