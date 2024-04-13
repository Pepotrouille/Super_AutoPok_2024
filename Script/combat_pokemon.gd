extends Node2D

class_name CombatPokemon

var local_pokemon : Pokemon;

static var game_stats : GameStats;

static var combat_script : CombatScript;

@export var index_in_team : int;

var next_place : CombatPokemon = null;

var is_from_player : bool;

func _ready():
	if game_stats == null:
		for node in get_tree().root.get_child(0).get_children():
			if node is GameStats:
				game_stats = node;
			if node is CombatScript:
				combat_script = node;


#Pour initialiser un PossessedPokemon avec un type de Pokemon
func set_combat_pokemon_kind(pokemon_kind : Pokemon.PokemonKind):
	set_combat_pokemon(Pokemon.create_pokemon(pokemon_kind))

#Pour initialiser un PossessedPokemon avec un Pokemon existant
func set_combat_pokemon(pokemon : Pokemon):
	local_pokemon = pokemon
	if(local_pokemon.get_parent() != null):
		local_pokemon.reparent(self)
	else:
		add_child(local_pokemon)
	local_pokemon.position=Vector2.ZERO
	local_pokemon.scale = Vector2.ONE * 1.5
	local_pokemon.position.y -= 50


func make_action():
	if local_pokemon != null:
		if index_in_team == 1:
			if is_from_player: 
				if combat_script.adv_pokemon_1.local_pokemon != null:
					print(local_pokemon.name, " attack ", combat_script.adv_pokemon_1.local_pokemon.name)
			else:
				if combat_script.player_pokemon_1.local_pokemon != null:
					print(local_pokemon.name, " attack ", combat_script.player_pokemon_1.local_pokemon.name)

func move(): 
	if local_pokemon != null:
		if next_place != null:
			if next_place.local_pokemon == null:
				next_place.set_combat_pokemon(local_pokemon)
				local_pokemon = null

