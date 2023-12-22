extends CharacterBody2D

#region Consts
const BASE_WEIGHT: float = 80.0
const BASE_SPEED: float = 100.0
const SPRINT_BASE_COST: int = 15
const SPEED_DECREASE_FACTOR: float = 5.6
const STAMINA_WEIGHT_FACTOR: float = -11.2
#endregion

#region Props
var Weight: float = BASE_WEIGHT
func modify_weight(value: float) -> void:
	Weight = clampf(Weight + value, BASE_WEIGHT, Weight + value)
	print("weight {0}".format([Weight]))


var Max_Health: int = 100
var _health: int = Max_Health
var Health: int = _health:
	set = _set_health,
	get = _get_health

func _set_health(value: int):
	_health = clampi(value, 0, Max_Health)
	if _health == 0:
		EventBus.game_over.emit()

func _get_health():
	return _health

var _out_of_stamina = false
var Max_Stamina: int = 100
var _stamina: int = Max_Stamina
var Stamina: int = _stamina:
	set = _set_stamina,
	get = _get_stamina
func _set_stamina(value: int):
	_stamina = clampi(value, 0, Max_Stamina)
	if _stamina > SPRINT_BASE_COST:
		_out_of_stamina = false
	if _stamina == 0:
		EventBus.player_event.emit("Out of Stamina")
		_out_of_stamina = true
func _get_stamina() -> int:
	return _stamina
#endregion

#region Nodes
@onready var sprite: Sprite2D = $sprite
@onready var anim: AnimationPlayer = $anim
@onready var footstep: AudioStreamPlayer2D = $footstep
@onready var hand: Node2D = $hand
# Floating Text Placeolder
@onready var ftPh: Node2D = $ftPh
#endregion

#region Lifetimes
func _ready() -> void:
	EventBus.player_event.connect(_on_player_event)
	emit_health_update()


func _physics_process(delta: float) -> void:
	move()
	actions()
#endregion

#region Actions
func move() -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	var speed = get_speed()
	
	velocity = direction * speed
	if velocity != Vector2.ZERO:
		anim.speed_scale = speed / BASE_SPEED
		anim.play("move")
		footstep.set_pitch_scale(randf_range(1.0, 2.3))
	else:
		anim.play("RESET")
		
	move_and_slide()
	
	if !is_facing_forward():
		sprite.set_flip_h(true)
	else:
		sprite.set_flip_h(false)

func actions():
	if can_shoot() and hand.is_action_shooting():
		hand.shoot()
		
	#if Input.is_action_just_pressed("action_a"):
	#	HudFactory.add_floating_text("action", ftPh)
	if Input.is_action_just_pressed("action_b"):
		HudFactory.add_floating_critical("action_b", ftPh)

func consume_stamina() -> void:
	var cost = SPRINT_BASE_COST * pow(BASE_WEIGHT / Weight, STAMINA_WEIGHT_FACTOR)
	Stamina -= cost
	emit_health_update()

func recover():
	if not is_sprinting() and not Utils.get_gate_by_name("player_consuming_stamina"):
		Stamina += Dice.roll(SPRINT_BASE_COST)
		emit_health_update()


#endregion 

#region CalculatedProps
func get_speed()  -> float:
	var base = BASE_SPEED * pow(BASE_WEIGHT / Weight, SPEED_DECREASE_FACTOR)
	var sprinting_now =  is_sprinting() and !_out_of_stamina
	var speed = (base * (2 if sprinting_now else 1))
	
	if Input.is_action_pressed("ads"):
		speed *= .2
	
	if sprinting_now:
		Utils.gated_timer("player_consuming_stamina", 1, consume_stamina)
	
	return speed

func is_facing_forward() -> bool:
	var mouse_pos = get_global_mouse_position()
	return mouse_pos.x >= global_position.x
	
func is_sprinting() -> bool:
	return can_sprint() and Input.is_action_pressed("sprint")

func can_sprint() -> bool:
	return !Input.is_action_pressed("ads")

func can_shoot() -> bool:
	return !is_sprinting()

#endregion 

#region Signals Handling
func _on_tick_timeout() -> void:
	recover()

func _on_player_event(message: String) ->void:
	HudFactory.add_floating_text(message, ftPh)

func emit_health_update():
	EventBus.player_health_update.emit(Health, Max_Health, Stamina, Max_Stamina)

#endregion
