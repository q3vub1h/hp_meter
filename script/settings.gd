extends Control

func _on_hp_value_changed(value: float) -> void:
	G.base_plr_hp = int(value)
