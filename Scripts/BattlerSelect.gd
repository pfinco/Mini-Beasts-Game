extends Node2D

var battlerList = []
var selectedBattler = Vector2(0, 0)

var team1 = []
var team2 = []

onready var selector = $Selector

func _ready():
	for _x in range(5):
		battlerList.append([])
	battlerList[0].append(preload("res://Scenes/Mini Beasts/Babaa.tscn"))
	battlerList[1].append(preload("res://Scenes/Mini Beasts/Stelluxe.tscn"))
	battlerList[2].append(preload("res://Scenes/Mini Beasts/Sapack.tscn"))
	battlerList[3].append(preload("res://Scenes/Mini Beasts/Eggin.tscn"))
	battlerList[4].append(preload("res://Scenes/Mini Beasts/Machirp.tscn"))

func _input(event):
	if event.is_action_pressed("ui_left") && selectedBattler.x > 0:
		selectedBattler.x -= 1
		selector.position.x -= 256
	elif event.is_action_pressed("ui_right") && selectedBattler.x < 4:
		selectedBattler.x += 1
		selector.position.x += 256
	elif event.is_action_pressed("ui_accept"):
		if team1.size() < 3:
			team1.append(battlerList[selectedBattler.x][selectedBattler.y])
			var battler = battlerList[selectedBattler.x][selectedBattler.y].instance()
			$ChosenBattlers.add_child(battler)
			battler.position = Vector2(0, (team1.size()) * Game.TILE_SIZE)
			$Team1.get_child(team1.size() - 1).text = battler.battlerName
		elif team2.size() < 3:
			team2.append(battlerList[selectedBattler.x][selectedBattler.y])
			var battler = battlerList[selectedBattler.x][selectedBattler.y].instance()
			$ChosenBattlers.add_child(battler)
			battler.position = Vector2(1792, (team2.size()) * Game.TILE_SIZE)
			$Team2.get_child(team2.size() - 1).text = battler.battlerName
		elif team2.size() >= 3:
			for b in team1:
				Game.party.append(b)
			for b in team2:
				Game.foes.append(b)
			get_tree().change_scene("res://Scenes/Map.tscn")
	elif event.is_action_pressed("ui_back"):
		if team2.size() >= 1:
			var index = team2.size() - 1
			team2.remove(index)
			$ChosenBattlers.remove_child($ChosenBattlers.get_child(index + 3))
			$Team2.get_child(index).text = ""
		elif team1.size() >= 1:
			var index = team1.size() - 1
			team1.remove(index)
			$ChosenBattlers.remove_child($ChosenBattlers.get_child(index))
			$Team1.get_child(index).text = ""
