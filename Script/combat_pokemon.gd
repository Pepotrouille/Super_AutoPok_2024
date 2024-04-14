extends Node2D

class_name CombatPokemon

var local_pokemon : Pokemon;

static var game_stats : GameStats;

static var combat_script : CombatScript;

@export var index_in_team : int;

var next_place : CombatPokemon = null;

var is_from_player : bool;

signal has_died;

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
	local_pokemon.show_life(true)
	local_pokemon.face_right(is_from_player)


func make_action():
	if local_pokemon != null:
		if index_in_team == 1:
			if is_from_player: 
				if combat_script.adv_pokemon_1.local_pokemon != null:
					combat_script.adv_pokemon_1.is_attacked(local_pokemon.attack)
			else:
				if combat_script.player_pokemon_1.local_pokemon != null:
					combat_script.player_pokemon_1.is_attacked(local_pokemon.attack)

func move(): 
	if local_pokemon != null:
		if next_place != null:
			if next_place.local_pokemon == null:
				next_place.set_combat_pokemon(local_pokemon)
				local_pokemon = null

func is_attacked(lost_pv:int):
	local_pokemon.change_current_life(-lost_pv)
	

func check_dying():
	if local_pokemon != null:
		if local_pokemon.life <= 0:
			dies()

func dies():
	print(name," dying")
	local_pokemon.queue_free()
	local_pokemon = null
	has_died.emit()

func set_is_from_player(new_is_from_player : bool):
	is_from_player = new_is_from_player

func set_next_place(new_next_place : CombatPokemon):
	next_place = new_next_place
