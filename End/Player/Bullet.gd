extends Area2D

const explosion_scn = preload("res://Effect/Explosion.tscn")

var speed = 800
var rotate_speed = 800


func _process(delta):
	position += transform.x * speed * delta


func explode():
	var explosion = explosion_scn.instance()
	get_parent().add_child(explosion)
	explosion.position = global_position
	explosion.rotation = global_rotation


func _on_Bullet_body_entered(body):
	if body.is_in_group("Enemies"):
		print("Bullet hit ", body.name)
		body.anim_player.play("hit")
		if body.life > 1:
			body.life -= 1
		else:
			explode()
			yield(body.anim_player, "animation_finished")
			body.queue_free()
	queue_free()



func _on_Bullet_area_entered(area):
	if area.is_in_group("Missiles"):
		print("Bullet hit ", area.name)
		explode()
		area.queue_free()
	queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

