extends CharacterBody2D

@export var speed: float = 260.0
@export var attack_cooldown: float = 0.35
@export var attack_duration: float = 0.12

@onready var body: Polygon2D = $Body
@onready var weapon: Node2D = $Weapon
@onready var slash: Line2D = $Weapon/Slash

var _attack_timer: float = 0.0
var _attack_anim_timer: float = 0.0


func _physics_process(delta: float) -> void:
	_move_player()
	look_at(get_global_mouse_position())
	_update_attack_timers(delta)
	if Input.is_action_just_pressed("attack"):
		_attack()


func _move_player() -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	move_and_slide()


func _update_attack_timers(delta: float) -> void:
	if _attack_timer > 0.0:
		_attack_timer -= delta

	if _attack_anim_timer > 0.0:
		_attack_anim_timer -= delta
		var progress := 1.0 - (_attack_anim_timer / attack_duration)
		weapon.rotation = lerp(-0.7, 0.9, progress)
	else:
		weapon.rotation = 0.0
		slash.visible = false


func _attack() -> void:
	if _attack_timer > 0.0:
		return

	_attack_timer = attack_cooldown
	_attack_anim_timer = attack_duration
	slash.visible = true
	weapon.rotation = -0.7
