extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass #set_winning_screen(won_credits : int)

func set_winning_screen(current_score : int, won_credits : int):
	$Score.text = "[center] Score actuel : " + str(current_score) + " [/center]"
	$Credits.text = "[center] Crédits gagnés : " + str(won_credits) + " [/center]"




func _on_continue_pressed():
	get_tree().change_scene_to_file("res://Scene/Levels/pokeshop.tscn")

func _on_quit_pressed():
	GameStats.get_instance().end_game()
	
