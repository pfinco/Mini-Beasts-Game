extends Node2D

var battlerList = []
var selectedBattler = Vector2(0, 0)

var team1 = []
var team2 = []

onready var selector = $Selector

onready var babaaPre = preload("res://Scenes/Mini Beasts/Babaa.tscn")
onready var stelluxePre = preload("res://Scenes/Mini Beasts/Stelluxe.tscn")
onready var sapackPre = preload("res://Scenes/Mini Beasts/Sapack.tscn")
onready var egginPre = preload("res://Scenes/Mini Beasts/Eggin.tscn")
onready var machirpPre = preload("res://Scenes/Mini Beasts/Machirp.tscn")
onready var honbatPre = preload("res://Scenes/Mini Beasts/Honbat.tscn")
onready var dustbunnyPre = preload("res://Scenes/Mini Beasts/Dustbunny.tscn")

func _ready():
	for _y in range(2):
		battlerList.append([])
	battlerList[0].append(babaaPre)
	battlerList[0].append(stelluxePre)
	battlerList[0].append(sapackPre)
	battlerList[0].append(egginPre)
	battlerList[0].append(machirpPre)
	battlerList[1].append(honbatPre)
	battlerList[1].append(dustbunnyPre)

func _input(event):
	# Move the selector
	if event.is_action_pressed("ui_left") && selectedBattler.x > 0:
		selectedBattler.x -= 1
		selector.position.x -= 256
	elif event.is_action_pressed("ui_right") && selectedBattler.x < battlerList[selectedBattler.y].size() - 1:
		selectedBattler.x += 1
		selector.position.x += 256
	elif event.is_action_pressed("ui_up") && selectedBattler.y > 0:
		selectedBattler.y -= 1
		selector.position.y -= 256
	elif event.is_action_pressed("ui_down") && selectedBattler.y < battlerList.size() - 1 && selectedBattler.x <= battlerList[selectedBattler.y + 1].size() - 1:
		selectedBattler.y += 1
		selector.position.y += 256

	# Add the battler the selector is on to a team
	elif event.is_action_pressed("ui_accept"):
		if team1.size() < 3:
			# If team one is not full, add the selected battler to team one
			team1.append(battlerList[selectedBattler.y][selectedBattler.x])
			var battler = battlerList[selectedBattler.y][selectedBattler.x].instance()
			$ChosenBattlers.add_child(battler)
			battler.position = Vector2(0, (team1.size()) * Game.TILE_SIZE)
			$Team1.get_child(team1.size() - 1).text = battler.battlerName
		elif team2.size() < 3:
			# If team one is full and team two is not, add the selected battler to team two
			team2.append(battlerList[selectedBattler.y][selectedBattler.x])
			var battler = battlerList[selectedBattler.y][selectedBattler.x].instance()
			$ChosenBattlers.add_child(battler)
			battler.position = Vector2(1792, (team2.size()) * Game.TILE_SIZE)
			$Team2.get_child(team2.size() - 1).text = battler.battlerName
		elif team2.size() >= 3:
			# If both teams are full, create a battle map with the teams
			for b in team1:
				Game.party.append(b)
			for b in team2:
				Game.foes.append(b)
			get_tree().change_scene("res://Scenes/Map.tscn")
			
	# Deselect the most recently selected battler
	elif event.is_action_pressed("ui_back"):
		if team2.size() >= 1:
			# If team two has battlers, remove the most recent battler from team two
			var index = team2.size() - 1
			team2.remove(index)
			$ChosenBattlers.remove_child($ChosenBattlers.get_child(index + 3))
			$Team2.get_child(index).text = ""
		elif team1.size() >= 1:
			# If team two has no battlers and team one does, remove the most recent battler from team one
			var index = team1.size() - 1
			team1.remove(index)
			$ChosenBattlers.remove_child($ChosenBattlers.get_child(index))
			$Team1.get_child(index).text = ""
