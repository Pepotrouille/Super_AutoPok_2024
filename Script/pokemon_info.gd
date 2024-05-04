extends Node2D

class_name PokemonInfo

func set_info(pokemon_name : String, max_life:int, current_life:int, attak_value:int, price:int, type: Pokemon.PokemonType, freq:int):
	set_pokemon_name(pokemon_name)
	set_max_life(max_life)
	set_current_life(current_life)
	set_attack(attak_value)
	set_price(price)
	set_type(type)
	set_freq_atk(freq)


func show_life(is_now_visible:bool):
	show_info(false)
	$LifeBar.visible = is_now_visible

func show_info(is_now_visible:bool):
	$LifeBar.visible = is_now_visible
	$NameDisplay.visible = is_now_visible
	$AttackDisplayValue.visible = is_now_visible
	$PriceDisplayValue.visible = is_now_visible
	$FreqAtkDisplayValue.visible = is_now_visible
	$Type.visible = is_now_visible
	$BG.visible = is_now_visible
	

func set_pokemon_name(pokemon_name : String):
	$NameDisplay.text = "[center]" + pokemon_name + "[/center]"

func set_max_life(max_life:int):
	$LifeBar.max_value = max_life
	set_text_on_progress_bar(str($LifeBar.value) + "/" + str($LifeBar.max_value))

func set_current_life(current_life:int):
	$LifeBar.value = current_life
	set_text_on_progress_bar(str($LifeBar.value) + "/" + str($LifeBar.max_value))

func set_attack(attak_value:int):
	$AttackDisplayValue.text = str(attak_value)

func set_price(price:int):
	$PriceDisplayValue.text = str(price)

func set_freq_atk(freq:int):
	$FreqAtkDisplayValue.text = str(freq)

func set_type(type: Pokemon.PokemonType):
	$Type.texture = load("res://Assets/Images/UI/Type/Type_" + Pokemon.PokemonType.keys()[type] +".png")

func change_current_life(delta_life:int):
	$LifeBar.value += delta_life
	set_text_on_progress_bar(str($LifeBar.value) + "/" + str($LifeBar.max_value))

func set_text_on_progress_bar(new_text:String):
	$LifeBar/LifeBarDisplay.text = "[center]" + new_text + "[/center]"
