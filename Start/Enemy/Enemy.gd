extends KinematicBody2D

signal enemy_killed

export var life = 3
export var speed = 20
export var interval = 0.2

onready var canon = $Canon
onready var muzzle = $Canon/Muzzle
onready var timer = $Timer
onready var anim_player = $AnimationPlayer


func _ready():
	anim_player.play("spawn")
	yield(anim_player, "animation_finished")
	timer.wait_time = interval
	timer.start()
	

func _physics_process(delta):
	if get_parent().has_node("Player"):
		var direction = global_position.direction_to(get_parent().get_node("Player").global_position)
		var velocity = direction * speed
		velocity = move_and_slide(velocity)
		rotation = lerp_angle(rotation, velocity.angle(), delta/2)
		canon.rotation = lerp_angle(canon.rotation, velocity.angle(), delta)


func _on_Timer_timeout():
	pass


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		timer.start()


func _on_Area2D_body_exited(body):
	if body.name == "Player":
		timer.stop()


func _on_Enemy_tree_exited():
	emit_signal("enemy_killed")
