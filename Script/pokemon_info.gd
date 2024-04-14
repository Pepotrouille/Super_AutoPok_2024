extends Node2D

class_name PokemonInfo

func show_life(is_now_visible:bool):
	show_info(false)
	$LifeBar.visible = is_now_visible

func show_info(is_now_visible:bool):
	$LifeBar.visible = is_now_visible
	$AttackDisplayValue.visible = is_now_visible
	$AttackIcon.visible = is_now_visible

func set_max_life(max_life:int):
	$LifeBar.max_value = max_life
	set_text_on_progress_bar(str($LifeBar.value) + "/" + str($LifeBar.max_value))

func set_current_life(current_life:int):
	$LifeBar.value = current_life
	set_text_on_progress_bar(str($LifeBar.value) + "/" + str($LifeBar.max_value))

func change_current_life(delta_life:int):
	$LifeBar.value += delta_life
	set_text_on_progress_bar(str($LifeBar.value) + "/" + str($LifeBar.max_value))

func set_attack(attak_value:int):
	$AttackDisplayValue.text = str(attak_value)

func set_text_on_progress_bar(new_text:String):
	$LifeBar/LifeBarDisplay.text = "[center]" + new_text + "[/center]"
