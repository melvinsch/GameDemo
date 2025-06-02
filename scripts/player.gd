class_name player extends CharacterBody2D

signal attack_finished

@onready var sprite_animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_component: healthComponent = $Components/HealthComponent


# var move_speed := 100
var move_speed := 1000
var attack_damage := 50
var is_attack = false

func _ready() -> void:
	health_component.death.connect(on_death)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		attack()

func _physics_process(delta: float) -> void:
	if !is_attack:
		var move_direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		# print(move_direction)
		if move_direction:
			velocity = move_speed * move_direction
			sprite_animation.play("run")
			if move_direction.x != 0:
				sprite_animation.flip_h = move_direction.x < 0
				$AreaAttack.scale.x = -1 if move_direction.x < 0 else 1
		else:
			velocity = velocity.move_toward(Vector2.ZERO, move_speed)
			sprite_animation.play("idle")
		move_and_slide()

func attack():
	sprite_animation.play("attack")
	is_attack = true

func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite_animation.animation == "attack":
		is_attack = false
		attack_finished.emit()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is enemy:
		body.in_attack_player_range = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is enemy:
		body.in_attack_player_range = false
		
func on_death():
	print("game over")
	get_tree().paused = true
	#work on it
