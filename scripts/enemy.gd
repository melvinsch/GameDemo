class_name enemy extends CharacterBody2D

var move_speed := 50
var attack_damage := 10
var is_attack := false
var in_attack_player_range := false

@onready var player: player = $"../Player"
@onready var sprite_animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_component: healthComponent = $Components/HealthComponent


func _ready() -> void:
	health_component.death.connect(on_death)
	if player:
		player.attack_finished.connect(verify_receive_damage)

func _physics_process(delta: float) -> void:
	if !is_attack and player:
		sprite_animation.play("run")
		var move_direction = (player.position - position).normalized()
		if move_direction:
			velocity = move_direction * move_speed
			if move_direction.x != 0:
				sprite_animation.flip_h = move_direction.x < 0
				$AreaAttack.scale.x = -1 if move_direction.x < 0 else 1
		move_and_slide()

func attack():
	sprite_animation.play("attack")
	is_attack = true

func verify_receive_damage():
	if in_attack_player_range:
		health_component.receive_damage(player.attack_damage)

#When player enters in attack area
func _on_area_attack_body_entered(body: Node2D) -> void:
	if body is player:
		attack()


func _on_area_attack_body_exited(body: Node2D) -> void:
	if body is player:
		is_attack = false


func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite_animation.animation == "attack":
		player.health_component.receive_damage(attack_damage)
		if is_attack:
			attack()
			
func on_death():
	queue_free()
