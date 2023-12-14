extends Node2D
class_name Weapon

@onready var Sprite: Sprite2D = $sprite
@onready var Anim: AnimationPlayer = $anim
@onready var ShotSnd: AudioStreamPlayer = $shot
@onready var Muzzle: Node2D = $sprite/muzzle

@onready var bullet = preload("res://actors/items/weapons/bullet.tscn")

var Type: Enums.Weapons = Enums.Weapons.Rifle
#var Bullet_Speed: float = 2500.0
var Bullet_Speed: float = 500.0
var Base_Damage: float = 80.0
var Recoil_Multiplier: Vector2 = Vector2(4.0, 15.0)
var Max_Ammo: int = 5
var BPM: float = 1.0

var _ammo: int = 5
var _is_aiming: bool = false
var _can_fire = true
var _is_reloading = false
var _is_ads = false


func _physics_process(delta: float) -> void:
	gun_orientation()

func gun_orientation():
	var aimed_point = get_global_mouse_position()
	
	look_at(aimed_point)
	
	if aimed_point.x < global_position.x:
		Sprite.set_flip_v(true)
	else:
		Sprite.set_flip_v(false)

func shoot() -> Vector2:
	if !_can_fire:
		return Vector2.ZERO
	_can_fire = false
	Anim.speed_scale = BPM
	ShotSnd.set_pitch_scale(randf_range(1.8, 2.2))
	var b: Node2D = bullet.instantiate()
	b.global_position = Muzzle.global_position
	get_tree().get_root().add_child(b)
	b.shoot(Bullet_Speed, Base_Damage, _is_ads)
	Anim.play("shoot")
	
	var vertical_recoil = 2 *Recoil_Multiplier.y
	if _is_ads:
		vertical_recoil /= 2
	return Vector2(
			randi_range(-Recoil_Multiplier.x, Recoil_Multiplier.x),
			-randi_range(0, vertical_recoil)
	)

func reset_can_fire() -> void:
	_can_fire = true

func ads_on() -> void:
	_is_ads = true
	
func ads_off() -> void:
	_is_ads = false
