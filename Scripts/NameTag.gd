extends ColorRect

func changeName(value):
	$Name.text = value

func changeHealth(hp, maxHp):
	$Health.text = String(hp) + "/" + String(maxHp)
