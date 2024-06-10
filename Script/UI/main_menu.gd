extends Node2D


func _ready():
	$CurrentBestScore.text = "[center]Meilleur score session actuelle"
	$CurrentBestScore.newline()
	$CurrentBestScore.append_text(str(GlobalData.current_best_score) )


func _on_start_pressed():
	$GameStats.reparent(get_tree().root)
	get_tree().change_scene_to_file("res://Scene/Levels/pokeshop.tscn")


func _on_credits_pressed():
	get_tree().change_scene_to_file("res://Scene/UI/credits.tscn")
