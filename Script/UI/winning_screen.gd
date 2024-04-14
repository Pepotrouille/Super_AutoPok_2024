extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_winning_screen(won_credits : int):
	pass




func _on_continue_pressed():
	get_tree().change_scene_to_file("res://Scene/Niveaux/pokeshop.tscn")

func _on_quit_pressed():
	get_tree().change_scene_to_file("res://Scene/UI/main_menu.tscn")
