extends Node2D

###--------------------------------------------------------------------
###-                              METHODS                             -
###--------------------------------------------------------------------
@export_category("Pokeshop's elements")
@export_group("Player Team")
@export var player_team : Array[Node2D];

@export_group("Ennemy Team")
@export var ennemy_team : Array[PreviewPokemon];
# Called when the node enters the scene tree for the first time.

@export_group("Pokemon To Buy")
@export var buyable_pokemons : Array[BuyablePokemon];
# Called when the node enters the scene tree for the first time.

@export_group("Pokeshop parameters")
@export var price_refill : int = 3;

###--------------------------------------------------------------------
###-                              METHODS                             -
###--------------------------------------------------------------------

##========================Set up====================

func _ready():
	var game_stats = GameStats.get_instance()
	game_stats._money_has_changed.connect(update_amount_money)
	update_amount_money(game_stats.money)
	$Score.text = "Score : " + str(game_stats.score)
	game_stats.increase_difficulty()
	#Met les pokémons présents dans game stats à l'initialisation
	randomize_pok_to_buy()
	print(GameStats.get_instance().pokemon_team[0])
	preview_ennemies()
	for i in range(0,6): 
		player_team[i].fill_place(game_stats.pokemon_team[i])
	$Change_Buyable/Change_Buyable_Text.text = "[center]Changer tirage"
	$Change_Buyable/Change_Buyable_Text.newline()
	$Change_Buyable/Change_Buyable_Text.append_text("(coûte " + str(price_refill) + " pokédollars)") 

func update_amount_money(total_amount:int):#Will be changed to hud scene after
	$Amount.text = (str(total_amount))

##========================Buyables====================

func randomize_pok_to_buy():
	var game_stats = GameStats.get_instance()
	buyable_pokemons[0].set_pokemon_to_buy(game_stats.csv_pokemon_database.get_random_pokemon())
	buyable_pokemons[0].position = buyable_pokemons[0].base_position
	buyable_pokemons[1].set_pokemon_to_buy(game_stats.csv_pokemon_database.get_random_pokemon())
	buyable_pokemons[1].position = buyable_pokemons[1].base_position
	buyable_pokemons[2].set_pokemon_to_buy(game_stats.csv_pokemon_database.get_random_pokemon())
	buyable_pokemons[2].position = buyable_pokemons[2].base_position


##========================Ennemy Preview====================

func preview_ennemies() -> void:
	var game_stats = GameStats.get_instance()
	var new_ennemy_team = game_stats.csv_pokemon_database.get_random_pokemon_team_depending_difficulty()
	game_stats.set_ennemy_team(new_ennemy_team)
	var i : int = 0
	for pok in new_ennemy_team: 
		ennemy_team[i].set_preview_pokemon(pok)
		i += 1

##========================Scene Buttons====================

func _on_fight_button_pressed():
	var game_stats = GameStats.get_instance()
	print(game_stats.size_team)
	if game_stats.size_team >0:
		for preview in ennemy_team:
			if preview.local_pokemon:
				preview.local_pokemon.reparent(game_stats)
			
			#evaluate("team_place_" + str(i) + "")
		get_tree().change_scene_to_file("res://Scene/niveau_test.tscn")
	else:
		print("Veuillez prendre au moins un pokémon dans votre équipe")

func _on_quit_pressed():
	GameStats.get_instance().end_game()

func _on_change_buyable_pressed():
	var game_stats = GameStats.get_instance()
	if game_stats.money >= price_refill:
		game_stats.change_money(-price_refill)
		update_amount_money(game_stats.money)
		randomize_pok_to_buy()
	else:
		#Mettre message
		print("Not enough money")


