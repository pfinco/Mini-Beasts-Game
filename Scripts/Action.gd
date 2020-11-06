extends Node2D

var moveName
var category
var type
var power
var accuracy
var effectChance
var description
var targetedTiles
var numTargets
var kbPower
var kbDirection

export var stats : Resource

func _ready():
	moveName = stats.moveName
	category = stats.category
	type = stats.type
	power = stats.power
	accuracy = stats.accuracy
	effectChance = stats.effectChance
	description = stats.description
	targetedTiles = stats.targetedTiles
	kbPower = stats.kbPower
	kbDirection = stats.kbDirection
