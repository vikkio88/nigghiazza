extends Weapon

func _ready() -> void:
	Type = Enums.Weapons.Pistol
	BPM = 1
	Recoil_Multiplier.y *= 1
	Max_Ammo = 5
