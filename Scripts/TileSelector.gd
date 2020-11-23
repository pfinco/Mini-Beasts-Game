extends Position2D

onready var anim = $AnimationPlayer

func get_position():
	return get_parent().position + position 

func move(direction):
	visible = true
	position += (Game.TILE_SIZE * direction)
