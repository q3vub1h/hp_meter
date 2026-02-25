extends Control

#TYPE_NIL = 0
#TYPE_BOOL = 1
#TYPE_INT = 2
#TYPE_FLOAT = 3
#TYPE_STRING = 4
#TYPE_VECTOR2 = 5
#TYPE_VECTOR2I = 6
#TYPE_RECT2 = 7
#TYPE_RECT2I = 8
#TYPE_VECTOR3 = 9
#TYPE_VECTOR3I = 10
#TYPE_TRANSFORM2D = 11
#TYPE_VECTOR4 = 12
#TYPE_VECTOR4I = 13
#TYPE_AABB = 16
#TYPE_BASIS = 17
#TYPE_TRANSFORM3D = 18
#TYPE_PROJECTION = 19
#TYPE_COLOR = 20
#TYPE_STRING_NAME = 21
#TYPE_NODE_PATH = 22
#TYPE_DICTIONARY = 27
#TYPE_ARRAY = 28
#TYPE_PACKED_BYTE_ARRAY = 29
#TYPE_PACKED_INT32_ARRAY = 30
#TYPE_PACKED_INT64_ARRAY = 31
#TYPE_PACKED_FLOAT32_ARRAY = 32
#TYPE_PACKED_FLOAT64_ARRAY = 33
#TYPE_PACKED_STRING_ARRAY = 34
#TYPE_PACKED_VECTOR2_ARRAY = 35
#TYPE_PACKED_VECTOR3_ARRAY = 36
#TYPE_PACKED_COLOR_ARRAY = 37
#TYPE_PACKED_VECTOR4_ARRAY = 38
#TYPE_MAX = 39

func _ready()->void:
	init_setts()

func init_setts()->void:
	for i in $v.get_children():
		if   i.has_node("s"): init_slider(i)
		elif i.has_node("t"): init_toggle(i)

func init_slider(i:HBoxContainer)->void:
	var sett:PackedStringArray = i.name.split(",")
	var sett_type:String = sett[0]
	var property_name:String = sett[1].replace("-","/")

	var value_type:String = sett[2]
	i.get_node("s").value_changed.connect(func(v:float):
		var nv = type_convert(v,int( value_type ) )
		i.get_node("c").text = str( nv )
		match_sett_type(sett_type,property_name,nv)
		)

func init_toggle(i:HBoxContainer)->void:
	var sett:PackedStringArray = i.name.split(",")
	var sett_type:String = sett[0]
	var property_name:String = sett[1].replace("-","/")
	i.get_node("t").toggled.connect(func(v:bool): match_sett_type(sett_type,property_name,v) )

func match_sett_type(type,property,v):
	match type:
		"e": Engine.set(property,v)
		"g": G.set(property,v)
		"ds": DisplayServer.set(property,v)
		"w": get_window().set(property,v)
		_: push_error("no such sett_type: ",type)
