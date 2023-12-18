extends CharacterBody2D


const BASE_SPEED: float = 100.0
@onready var sprite: Sprite2D = $sprite
@onready var anim: AnimationPlayer = $anim
@onready var footstep: AudioStreamPlayer2D = $footstep
@onready var hand: Node2D = $hand
# Floating Text Placeolder
@onready var ftPh: Node2D = $ftPh

func _ready() -> void:
	EventBus.player_event.connect(_on_player_event)


func _physics_process(delta: float) -> void:
	move()
	actions()
	
#	if hand.has_gun():
#		print("gun")
	
func move() -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	var speed = get_speed()
	
	velocity = direction * speed
	if velocity != Vector2.ZERO:
		anim.speed_scale = speed / BASE_SPEED
		anim.play("move")
		footstep.set_pitch_scale(randf_range(1.0, 2.3))
		
		# TODO: add draining stamina
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

func get_speed()  -> float:
	var sprinting_now =  is_sprinting()
	var speed = (BASE_SPEED * (2 if sprinting_now else 1))
	
	if Input.is_action_pressed("ads"):
		speed *= .2
	
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

func _on_player_event(message: String) ->void:
	HudFactory.add_floating_text(message, ftPh)
