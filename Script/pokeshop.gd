extends Node2D

var game_stats = GameStats
# Called when the node enters the scene tree for the first time.
func _ready():
	$BuyablePokemon1.set_pokemon_to_buy(Pokemon.PokemonKind.HERICENDRE)
	$BuyablePokemon2.set_pokemon_to_buy(Pokemon.PokemonKind.SALAMECHE)
	$BuyablePokemon3.set_pokemon_to_buy(Pokemon.PokemonKind.HERICENDRE)
	
	for node in get_children():
		if node is GameStats:
			game_stats = node
			game_stats._money_has_changed.connect(update_amount_money)
	update_amount_money(game_stats.money)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func update_amount_money(total_amount:int):#Will be changed to hud scene after
	$Amount.text = ("Credits: " + str(total_amount))

func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scene/niveau_test.tscn")
