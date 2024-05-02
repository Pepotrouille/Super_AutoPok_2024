extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass #set_winning_screen(won_credits : int)

func set_winning_screen(won_credits : int):
	$Credits.text = "[center] Crédits gagnés : " + str(won_credits) + " [/center]"




func _on_continue_pressed():
	get_tree().change_scene_to_file("res://Scene/Niveaux/pokeshop.tscn")

func _on_quit_pressed():
	get_tree().change_scene_to_file("res://Scene/UI/main_menu.tscn")