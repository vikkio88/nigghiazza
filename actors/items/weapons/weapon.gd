extends Node2D
class_name Weapon

@onready var Sprite: Sprite2D = $sprite
# The Shooting Animation
@onready var _shoot_anim: AnimationPlayer = $anim_shoot
@onready var Anims: AnimationPlayer = $anim

@onready var _shot_snd: AudioStreamPlayer = $shot
@onready var _dry_snd: AudioStreamPlayer = $dry
@onready var Muzzle: Node2D = $sprite/muzzle

@onready var bullet = preload("res://actors/items/weapons/bullet.tscn")

var Type: Enums.Weapons = Enums.Weapons.Rifle
#var Bullet_Speed: float = 2500.0
var Bullet_Speed: float = 500.0
var Base_Damage: float = 80.0
var Recoil_Multiplier: Vector2 = Vector2(4.0, 15.0)
var Max_Ammo: int = 5
var BPM: float = 1.0
var Weight: float = 3

var _ammo: int = 5
var _is_aiming: bool = false
var _is_shooting: bool = false
var _is_inspecting: bool = false
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
	if !_can_fire():
		if _ammo < 1 and !_dry_snd.is_playing():
			_shot_snd.set_pitch_scale(randf_range(1.8, 2.2))
			_dry_snd.play()
		return Vector2.ZERO
	_is_shooting = true
	_shoot_anim.speed_scale = BPM
	_shot_snd.set_pitch_scale(randf_range(1.8, 2.2))
	var b: Node2D = bullet.instantiate()
	b.global_position = Muzzle.global_position
	get_tree().get_root().add_child(b)
	b.shoot(Bullet_Speed, Base_Damage, _is_ads)
	_shoot_anim.play("shoot")
	_post_shoot()
	
	var vertical_recoil = 2 *Recoil_Multiplier.y
	if _is_ads:
		vertical_recoil /= 2
	return Vector2(
			randi_range(-Recoil_Multiplier.x, Recoil_Multiplier.x),
			-randi_range(0, vertical_recoil)
	)

func reset() -> void:
	_is_shooting = false

func ads_on() -> void:
	_is_ads = true
	
func ads_off() -> void:
	_is_ads = false
	
func set_ammo(ammo: int) -> void:
	_ammo = ammo

func _post_shoot() -> void:
	_ammo -= 1
	print_debug(_ammo)

func _can_fire() -> bool:
	return _can_action() && _ammo > 0

func _can_action() -> bool:
	return !_is_shooting && !_is_inspecting && !_is_reloading

func inspect() -> void:
	if !_can_action():
		return
		
	EventBus.player_event.emit("Checking ammo...")
	_is_inspecting = true
	Anims.play("inspect")

func reload() -> void:
	if !_can_action():
		return
		
	EventBus.player_event.emit("Reloading...")
	_is_reloading = true
	Anims.play("reload")
	
func _finish_inspect() -> void:
	_is_inspecting = false
	EventBus.player_event.emit("{0}/{1}".format([_ammo,Max_Ammo]))

func _finish_reload() -> void:
	_is_reloading = false
	_ammo = Max_Ammo
	EventBus.player_event.emit("{0}/{1}".format([_ammo,Max_Ammo]))
