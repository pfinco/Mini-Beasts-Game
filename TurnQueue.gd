extends Node2D

var map
var activeBattler
var phase

var phases = {
	"none" : 0,
	"move" : 1,
	"attack" : 2
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
			if event.is_action_pressed("ui_accept") && activeBattler.selector.position != Vector2.ZERO:
				activeBattler.position += activeBattler.selector.position
				activeBattler.selector.position = Vector2.ZERO
				activeBattler.selector.visible = false
				change_turn()
			elif event.is_action_pressed("ui_left") && activeBattler.position.x + activeBattler.selector.position.x > 0:
				activeBattler.selector.visible = true
				activeBattler.selector.position.x -= 128
			elif event.is_action_pressed("ui_right") && activeBattler.position.x + activeBattler.selector.position.x < (map.width - 1 )* 128:
				activeBattler.selector.visible = true
				activeBattler.selector.position.x += 128
			elif event.is_action_pressed("ui_up") && activeBattler.position.y + activeBattler.selector.position.y > 0:
				activeBattler.selector.visible = true
				activeBattler.selector.position.y -= 128
			elif event.is_action_pressed("ui_down") && activeBattler.position.y + activeBattler.selector.position.y < (map.height - 1)* 128:
				activeBattler.selector.visible = true
				activeBattler.selector.position.y += 128
