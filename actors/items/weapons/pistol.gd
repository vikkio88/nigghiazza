extends Weapon

func _ready() -> void:
	Type = Enums.Weapons.Pistol
	Weight = .9
	BPM = 1
	Recoil_Multiplier.y *= 1
	Max_Ammo = 5
