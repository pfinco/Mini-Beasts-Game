extends Sprite

func _on_Tile_tileConverted(type):
	match type:
		TestMap.types.plain:
			texture = load("res://Sprites/PlainTerrain.png")
		TestMap.types.lush:
			texture = load("res://Sprites/LushTerrain.png")
		TestMap.types.water:
			texture = load("res://Sprites/WaterTerrain.png")
		TestMap.types.snow:
			texture = load("res://Sprites/SnowyTerrain.png")
		TestMap.types.sand:
			texture = load("res://Sprites/SandyTerrain.png")
		TestMap.types.rocks:
			texture = load("res://Sprites/RockyTerrain.png")
		TestMap.types.scorched:
			texture = load("res://Sprites/ScorchedTerrain.png")
		TestMap.types.foul:
			texture = load("res://Sprites/FoulTerrain.png")
		TestMap.types.charged:
			texture = load("res://Sprites/ChargedTerrain.png")
		TestMap.types.metal:
			texture = load("res://Sprites/MetalTerrain.png")
		TestMap.types.enchanted:
			texture = load("res://Sprites/EnchantedTerrain.png")
		TestMap.types.warped:
			texture = load("res://Sprites/WarpedTerrain.png")
