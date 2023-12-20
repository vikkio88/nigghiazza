extends Weapon

func _ready() -> void:
	Type = Enums.Weapons.AR
	Weight = 3.0
	BPM = 4.5
	Recoil_Multiplier.y *= 1.3
	Max_Ammo = 30
