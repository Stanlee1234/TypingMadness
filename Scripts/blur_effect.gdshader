shader_type canvas_item;

// Grabs the screen right behind the UI
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float blur_amount : hint_range(0.0, 5.0) = 2.5;

void fragment() {
	// Blurs the background
	vec4 color = textureLod(screen_texture, SCREEN_UV, blur_amount);
	// Slightly darkens the blurred background so text pops
	color.rgb *= 0.6; 
	COLOR = color;
}