extends VBoxContainer

var score = 0

onready var life_label = $LifeLabel
onready var score_label = $ScoreLabel


func update_life(latest_life):
	life_label.text = "Life: " + str(latest_life)


func update_score():
	score += 1
	score_label.text = "Score: " + str(score)
