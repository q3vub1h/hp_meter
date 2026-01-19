extends Control

var player_temp:PackedScene = preload("res://scene/player.tscn")

func _ready() -> void:
	S.plr_deleted.connect(func():recalc_circle())
	S.plr_count_changed.connect(_on_plr_count_changed)

	init_plrs()

func init_plrs()->void:
	for i:int in range(G.max_plrs):
		_add_player(i)

func _add_player(plr_n:int)->void:
	var path_follow:PathFollow2D = PathFollow2D.new()
	path_follow.hide()
	$path.add_child(path_follow)

	var p:Control = player_temp.instantiate()
	path_follow.add_child(p)

	p.plr_number = plr_n
	p.set_hp(G.base_plr_hp)

func _on_load_icon_file_selected(path: String) -> void:
	var image = Image.load_from_file(path)
	var texture:ImageTexture = ImageTexture.create_from_image(image)

	G.changing_icon_for.texture = texture

func _on_plr_count_changed(n_plrs:int)->void:
	var bg_rot:float = 0
	# cause on android shader works different than on pc
	if OS.has_feature("android"):
		match n_plrs:
			1: bg_rot = 0
			2: bg_rot = -180
			3: bg_rot = -150
			4: bg_rot = -135
			5: bg_rot = -126
			6: bg_rot = -120
			7: bg_rot = -115.8
			8: bg_rot = -112
	else:
		match n_plrs:
			1: bg_rot = 0
			2: bg_rot = 0
			3: bg_rot = -30
			4: bg_rot = -45
			5: bg_rot = -55
			6: bg_rot = -60
			7: bg_rot = -65
			8: bg_rot = -67.5
	$bg.rotation_degrees = bg_rot

### CONTROL PANEL

func _on_setts_pressed() -> void:
	$menu.show_menu("settings")

func _on_reset_pressed() -> void:
	for i in $path.get_children():
		var p:Control = i.get_child(0)
		p.set_hp(G.base_plr_hp)

func _on_add_player_pressed()->void:
	show_hidden_plr()

func _on_d_20_pressed() -> void:
	var s:Button = $control_panel/d20
	s.text = str( randi_range(1,20) )
	s.self_modulate = Color.RED
	await get_tree().create_timer(1).timeout
	s.self_modulate = Color.WHITE

### FUNCTIONS

func show_hidden_plr()->void:
	for i:PathFollow2D in $path.get_children():
		if i.visible==false:
			i.show()
			G.plr_count+=1
			S.plr_count_changed.emit(G.plr_count)
			recalc_circle()
			return

func has_hidden_plr()->bool:
	for i in $path.get_children():
		if i.visible==false: return true
	return false

func recalc_circle()->void:
	var progress_ratio:float = 1/float(G.plr_count)

	var plr_count:int = 0
	for pf:PathFollow2D in $path.get_children():
		if pf.visible==false:continue
		pf.progress_ratio = progress_ratio*plr_count
		plr_count+=1
