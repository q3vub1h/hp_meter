shader_type canvas_item;

uniform int num_colors = 0;
uniform vec4 colors[8] : source_color;
uniform float blur_strength : hint_range(0., .1, .005) = .0;

void fragment() {
	float angle = (atan(.5-UV.y, UV.x-.5) + PI)/(2.0*PI);
	float ratio = 1.0/float(num_colors);
	float cur_ratio = 0.0;
	
	COLOR = mix(colors[num_colors - 1],colors[0], smoothstep(blur_strength, .0, 1. - angle));
	for (int i = 0; i < num_colors-1; i++) {
		cur_ratio += ratio;
		if (angle < cur_ratio) {
			COLOR = mix(colors[i],colors[i+1], smoothstep(blur_strength, .0, abs(angle-cur_ratio)));
			break;
		}
	}
	//COLOR.a = min(COLOR.a, smoothstep(0, blur_strength*2., relative_size*.5 - r));
}
