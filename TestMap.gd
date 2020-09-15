extends Node2D

var types = {
	"plain" : 0,
	"lush" : 1,
	"water" : 2,
	"snow" : 3,
	"sand" : 4,
	"rocks" : 5,
	"scorched" : 6,
	"foul" : 7,
	"charged" : 8,
	"metal" : 9,
	"enchanted" : 10,
	"warped" : 11
}

func _process(_delta):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
