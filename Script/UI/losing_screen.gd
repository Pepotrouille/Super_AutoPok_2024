extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass #set_winning_screen(won_credits : int)

func set_losing_screen(final_score : int):
	$Score.text = "[center] Score final : " + str(final_score) + " [/center]"



func _on_quit_pressed():
	GameStats.get_instance().end_game()
