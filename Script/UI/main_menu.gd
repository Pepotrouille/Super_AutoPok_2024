extends Node2D


func _on_start_pressed():
	$GameStats.reparent(get_tree().root)
	get_tree().change_scene_to_file("res://Scene/Niveaux/pokeshop.tscn")
