extends Node

signal game_over()
signal game_event(message: String)
signal game_info(text: String)

signal interactable_on(item: String, action: String, callback: Callable)
signal interactable_off()

signal gun_pickup(type: Enums.Weapons, ammo: int)
signal gun_dropped(type: Enums.Weapons, position: Vector2, ammo_left: int)

signal player_event(message: String)
signal player_health_update(health: int, max_health: int, stamina: int, max_stamina: int)
