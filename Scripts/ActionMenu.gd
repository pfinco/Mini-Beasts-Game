extends Node2D

onready var itemPre = preload("res://Scenes/ActionMenuItem.tscn")
var selectedAction

func populateList(actions):
	for action in actions:
		var item = itemPre.instance()
		item.changeText(action.moveName)
		item.action = action
		add_child(item)
		item.position = Vector2(0, action.get_index() * 30)
	var item = itemPre.instance()
	item.changeText("Pass Turn")
	add_child(item)
	item.position = Vector2(0, actions.size() * 30)
	selectedAction = 0
	update()

func _input(event):
	if event.is_action_pressed("ui_down"):
		if selectedAction == get_child_count() - 1:
			selectedAction = 0
		else:
			selectedAction += 1
		update()
	elif event.is_action_pressed("ui_up"):
		if selectedAction == 0:
			selectedAction = get_child_count() - 1
		else:
			selectedAction -= 1
		update()

func update():
	for item in get_children():
		item.changeColor(Color(0.1, 0.1, 0.1))
	get_child(selectedAction).changeColor(Color(0.5, 0.5, 0))
