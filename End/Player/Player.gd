extends KinematicBody2D

signal player_hit

const bullet_scn = preload("res://Player/Bullet.tscn")

var life = 5
var speed = 400
var velocity = Vector2()
var interval = 0

onready var sprite = $Plane
onready var right_gun = $RightGun
onready var left_gun = $LeftGun
onready var anim_player = $AnimationPlayer


func _ready():
	right_gun.hide()
	left_gun.hide()


func _physics_process(delta):
	move()
	shoot(delta)


func move():
	velocity = Vector2()
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	velocity = velocity.normalized() * speed
	velocity = move_and_slide(velocity)
	if not velocity == Vector2.ZERO:
		rotation = lerp_angle(rotation, velocity.angle(), 0.2)


func shoot(time):
	interval += time
	if interval > 0.1:
		interval = 0
		if Input.is_action_pressed("shoot"):
			right_gun.show()
			left_gun.show()
			
			var right_bullet = bullet_scn.instance()
			right_bullet.rotation = global_rotation
			right_bullet.position = right_gun.global_position
			get_parent().add_child(right_bullet)
			
			var left_bullet = bullet_scn.instance()
			left_bullet.rotation = global_rotation
			left_bullet.position = left_gun.global_position
			get_parent().add_child(left_bullet)
	else:
		right_gun.hide()
		left_gun.hide()
