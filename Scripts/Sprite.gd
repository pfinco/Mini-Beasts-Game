extends Sprite

func _on_Tile_tileConverted(type):
	match type:
		Game.terrainTypes.plain:
			texture = load("res://Sprites/Terrain/PlainTerrain.png")
		Game.terrainTypes.lush:
			texture = load("res://Sprites/Terrain/LushTerrain.png")
		Game.terrainTypes.water:
			texture = load("res://Sprites/Terrain/WaterTerrain.png")
		Game.terrainTypes.snow:
			texture = load("res://Sprites/Terrain/SnowyTerrain.png")
		Game.terrainTypes.sand:
			texture = load("res://Sprites/Terrain/SandyTerrain.png")
		Game.terrainTypes.rocks:
			texture = load("res://Sprites/Terrain/RockyTerrain.png")
		Game.terrainTypes.scorched:
			texture = load("res://Sprites/Terrain/ScorchedTerrain.png")
		Game.terrainTypes.foul:
			texture = load("res://Sprites/Terrain/FoulTerrain.png")
		Game.terrainTypes.charged:
			texture = load("res://Sprites/Terrain/ChargedTerrain.png")
		Game.terrainTypes.metal:
			texture = load("res://Sprites/Terrain/MetalTerrain.png")
		Game.terrainTypes.enchanted:
			texture = load("res://Sprites/Terrain/EnchantedTerrain.png")
		Game.terrainTypes.warped:
			texture = load("res://Sprites/Terrain/WarpedTerrain.png")
