extends Node2D

class_name MovablePokemon

var local_pokemon : Pokemon;

static var current_selected : Pokemon = null;

static var game_stats : GameStats;

var is_hovered : bool = false;

var is_moving : bool = false;

var is_dropped : bool = true;

var base_position : Vector2;

signal _pokemon_is_moving();
signal _pokemon_is_not_moving();

func _ready():
	base_position = position
	if game_stats == null:
		for node in get_tree().root.get_child(0).get_children():
			if node is GameStats:
				game_stats = node;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_mouse_button_pressed( 1 ): # Click Gauche
		if is_moving: #Déplacemenyt avec la souris si sélectionné
			position = get_global_mouse_position()
		elif is_hovered and current_selected == null: #Sélectionne pokémon si aucun sélectionné
			_pokemon_is_moving.emit()
			current_selected = local_pokemon;
			current_selected.z_index=5;
			is_moving = true;
			is_dropped = false;
	elif is_moving: #Click souris laché, mais pas immobile (position initiale non-atteinte)
		if position.distance_squared_to(base_position)<50:
			_pokemon_is_not_moving.emit()
			is_moving = false;
			position = base_position;
			if current_selected:
				current_selected.z_index=0;
				current_selected = null
		else:
			if is_dropped:
				position = (position - base_position)/2 + base_position
			else:
				_dropped_on_areas()
				is_dropped = true;
			
			
func _on_pokemon_mouse_entered():
	if current_selected == null:
		is_hovered = true;

func _on_pokemon_mouse_exited():
	is_hovered = false

func _dropped_on_areas():
	pass
