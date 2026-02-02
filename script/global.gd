extends Node

@onready var main = get_tree().current_scene

var changing_icon_for:TextureRect = null
var plrs:Array[String] = []
var plr_count:int = 0:
	set(nv):
		plr_count=nv
		main.get_node("bg").material.set_shader_parameter("num_colors",plr_count)

var base_plr_hp:int = 20
var d_max_value:int = 20

var max_plrs:int=8
