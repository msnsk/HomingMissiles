extends Node2D

const enemy_scn = preload("res://Enemy/Enemy.tscn")

var shadow_offset = Vector2(0, 64)
var spawn_point: Vector2

onready var player = $Player
onready var shadow = $Shadow
onready var enemy = $Enemy
onready var hud = $UI/HUD


func _ready():
	randomize()
	player.connect("player_hit", self, "_on_Player_hit")
	spawn_enemy()


func _physics_process(_delta):
	move_shadow()


func move_shadow():
	shadow.position = player.position + shadow_offset
	shadow.get_node("Sprite").rotation = player.rotation


func spawn_enemy():
	var count = 0
	for child in get_children():
		if child.is_in_group("Enemies"):
			count += 1
	if count == 0:
		for i in 5:
			enemy = enemy_scn.instance()
			spawn_point = Vector2(player.position.x + rand_range(-600, 600), player.position.y + rand_range(-400, 400))
			enemy.position = spawn_point
			enemy.connect("enemy_killed", self, "spawn_enemy")
			enemy.connect("enemy_killed", self, "_on_Enemy_killed")
			call_deferred("add_child", enemy)

# Signal connected 
func _on_Player_hit():
	hud.update_life(player.life)

# Signal connected 
func _on_Enemy_killed():
	hud.update_score()
