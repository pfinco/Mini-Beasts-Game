extends Sprite

func _on_Tile_tileConverted(type):
	match type:
		TestMap.terrainTypes.plain:
			texture = load("res://Sprites/PlainTerrain.png")
		TestMap.terrainTypes.lush:
			texture = load("res://Sprites/LushTerrain.png")
		TestMap.terrainTypes.water:
			texture = load("res://Sprites/WaterTerrain.png")
		TestMap.terrainTypes.snow:
			texture = load("res://Sprites/SnowyTerrain.png")
		TestMap.terrainTypes.sand:
			texture = load("res://Sprites/SandyTerrain.png")
		TestMap.terrainTypes.rocks:
			texture = load("res://Sprites/RockyTerrain.png")
		TestMap.terrainTypes.scorched:
			texture = load("res://Sprites/ScorchedTerrain.png")
		TestMap.terrainTypes.foul:
			texture = load("res://Sprites/FoulTerrain.png")
		TestMap.terrainTypes.charged:
			texture = load("res://Sprites/ChargedTerrain.png")
		TestMap.terrainTypes.metal:
			texture = load("res://Sprites/MetalTerrain.png")
		TestMap.terrainTypes.enchanted:
			texture = load("res://Sprites/EnchantedTerrain.png")
		TestMap.terrainTypes.warped:
			texture = load("res://Sprites/WarpedTerrain.png")
