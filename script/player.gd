extends Control

@export var plr_number:int = 0
@export var hp:int = 20

var hp_changes:int = 0

func _on_visibility_changed() -> void:
	if visible==true:
		S.plr_added.emit(self)
		set_hp(G.base_plr_hp)
	else:
		S.plr_deleted.emit(self)

func _on_texture_button_pressed() -> void:
	var popup:FileDialog = G.main.get_node("load_icon")
	if OS.has_feature("android"):
		OS.request_permission("android.permission.READ_EXTERNAL_STORAGE")
		OS.request_permission("android.permission.READ_MEDIA_IMAGES")
	G.changing_icon_for = $icon
	G.main.get_node("load_icon").popup()

func change_hp(i:int)->void:
	hp+=i
	hp_changes+=i
	$hp_changes.show()
	$hp_changes.text = str(hp_changes) if hp_changes < 0 else "+"+str(hp_changes)
	$hp_off_timer.start()
	$hp.text = str(hp)
	change_font_size()

func _on_plus_pressed() -> void:
	change_hp(1)

func _on_minus_pressed() -> void:
	change_hp(-1)

func set_hp(i:int)->void:
	hp=i
	$hp.text=str(hp)

func _on_plr_color_picker_color_changed(color: Color) -> void:
	var bg_mat:ShaderMaterial = G.main.get_node("bg").material
	var cur_colors:PackedColorArray = bg_mat.get_shader_parameter("colors")

	cur_colors[plr_number] = color

	var new_colors:PackedColorArray = cur_colors

	bg_mat.set_shader_parameter("colors",new_colors)

func _on_hp_off_timer_timeout() -> void:
	hp_changes=0
	$hp_changes.hide()

func change_font_size()->void:
	var l:int = $hp.text.length()
	match l:
		3: $hp.add_theme_font_size_override(&"font_size",90)
		_: $hp.add_theme_font_size_override(&"font_size",130)
