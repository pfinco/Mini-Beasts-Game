extends Sprite

func _on_Tile_tileConverted(type):
	match type:
		TestMap.terrainTypes.plain:
			texture = load("res://Sprites/Terrain/PlainTerrain.png")
		TestMap.terrainTypes.lush:
			texture = load("res://Sprites/Terrain/LushTerrain.png")
		TestMap.terrainTypes.water:
			texture = load("res://Sprites/Terrain/WaterTerrain.png")
		TestMap.terrainTypes.snow:
			texture = load("res://Sprites/Terrain/SnowyTerrain.png")
		TestMap.terrainTypes.sand:
			texture = load("res://Sprites/Terrain/SandyTerrain.png")
		TestMap.terrainTypes.rocks:
			texture = load("res://Sprites/Terrain/RockyTerrain.png")
		TestMap.terrainTypes.scorched:
			texture = load("res://Sprites/Terrain/ScorchedTerrain.png")
		TestMap.terrainTypes.foul:
			texture = load("res://Sprites/Terrain/FoulTerrain.png")
		TestMap.terrainTypes.charged:
			texture = load("res://Sprites/Terrain/ChargedTerrain.png")
		TestMap.terrainTypes.metal:
			texture = load("res://Sprites/Terrain/MetalTerrain.png")
		TestMap.terrainTypes.enchanted:
			texture = load("res://Sprites/Terrain/EnchantedTerrain.png")
		TestMap.terrainTypes.warped:
			texture = load("res://Sprites/Terrain/WarpedTerrain.png")
