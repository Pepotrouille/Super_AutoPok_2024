extends MovablePokemon

class_name BuyablePokemon

func set_pokemon_to_buy(pokemon : Pokemon):
	if local_pokemon:
		local_pokemon.queue_free()
	local_pokemon = pokemon
	local_pokemon.mouse_entered.connect(_on_pokemon_mouse_entered)
	local_pokemon.mouse_exited.connect(_on_pokemon_mouse_exited)
	add_child(local_pokemon)
	#print("À vendre : ",local_pokemon.name)
	local_pokemon.show_info(false)

func _dropped_on_areas():
	for area in local_pokemon.get_overlapping_areas():
		if area is TeamEmptyPlace:
			buy_pokemon_in_empty_place(area)

func buy_pokemon_in_empty_place(team_empty_place : TeamEmptyPlace):
	var game_stats = GameStats.get_instance()
	if current_selected != null: #Avoid using two places with one pokemon
		if game_stats.money - local_pokemon.price < 0:
			print('Achat impossible. ', local_pokemon.price - game_stats.money, " crédits manquants.")
		else:
			current_selected = null;
			is_moving = false;
			game_stats._change_money.emit(-local_pokemon.price)
			team_empty_place.fill_place(local_pokemon)
			_pokemon_is_not_moving.emit()
			local_pokemon = null
