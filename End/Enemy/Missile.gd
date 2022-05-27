extends Node2D

const smoke_scn = preload("res://Effect/Smoke.tscn")
const explosion_scn = preload("res://Effect/Explosion.tscn")

export var speed = 400
export var steering_force = 20.0

var velocity = Vector2()
var acceleration = Vector2()
var target = null
var smoke_count = 0


func _physics_process(delta):
	velocity = transform.x * speed
	acceleration += steer()
	velocity += acceleration * delta
	velocity = velocity.clamped(speed)
	position += velocity * delta
	rotation = velocity.angle()
	
	smoke_count += delta
	if smoke_count > 0.05:
		smoke_count = 0
		spawn_smoke()


func steer():
	var steering = Vector2()
	var ideal_velocity = (target.position - position).normalized() * speed
	steering = (ideal_velocity - velocity).normalized() * steering_force
	return steering


func spawn_smoke():
	var smoke = smoke_scn.instance()
	get_parent().add_child(smoke)
	smoke.position = global_position
	smoke.rotation = global_rotation


func explode():
	var explosion = explosion_scn.instance()
	get_parent().add_child(explosion)
	explosion.position = global_position
	explosion.rotation = global_rotation


func _on_Missile_body_entered(body):
	if body.name == "Player":
		print("Missile hit ", body.name)
		body.anim_player.play("hit")
		body.emit_signal("player_hit")
		if body.life > 1:
			body.life -= 1
		else:
			explode()
			yield(body.anim_player, "animation_finished")
			body.queue_free()
			print("Game Over!")
			get_tree().quit()
	explode()
	queue_free()


func _on_Timer_timeout():
	explode()
	queue_free()
