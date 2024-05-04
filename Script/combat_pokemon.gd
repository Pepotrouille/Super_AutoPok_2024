extends Node2D

class_name CombatPokemon

var local_pokemon : Pokemon;

static var combat_script : CombatScript;

@export var index_in_team : int;

var next_place : CombatPokemon = null;

var is_from_player : bool;

signal has_died;

func _ready():
	for node in get_parent().get_children():
		if node is CombatScript:
			combat_script = node;

#Pour initialiser un PossessedPokemon avec un Pokemon existant
func set_combat_pokemon(pokemon : Pokemon):
	if pokemon != null:
		local_pokemon = pokemon
		if(local_pokemon.get_parent() != null):
			local_pokemon.reparent(self)
		else:
			add_child(local_pokemon)
		local_pokemon.position=Vector2.ZERO
		local_pokemon.scale = Vector2.ONE * 1.5
		local_pokemon.position.y += 20
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
	if !is_from_player:
		GameStats.get_instance().add_score(local_pokemon.price)
	local_pokemon.queue_free()
	local_pokemon = null
	has_died.emit()

func set_is_from_player(new_is_from_player : bool):
	is_from_player = new_is_from_player

func set_next_place(new_next_place : CombatPokemon):
	next_place = new_next_place
