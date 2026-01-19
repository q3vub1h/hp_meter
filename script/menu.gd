extends Control

func _ready() -> void:
	hide()
	hide_all_menus()

func hide_all_menus()->void:
	for i in $menus.get_children():
		i.hide()

func show_menu(menu_name:String)->void:
	show()
	hide_all_menus()
	if $menus.get_node(menu_name)==null: printerr("no such menu "+menu_name);return
	$menus.get_node(menu_name).show()

func _on_close_btn_pressed() -> void:
	hide()
