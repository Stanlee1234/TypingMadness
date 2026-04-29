shader_type canvas_item;
render_mode unshaded, skip_vertex_transform;

const float curvature = 10.0;
const float vignette_multiplier = 0.2;

uniform sampler2D screen_texture: hint_screen_texture, filter_linear_mipmap;

void fragment() {
    // 1. Warp the UVs for the CRT "bulge"
	vec2 centered_uv = SCREEN_UV * 2.0 - 1.0;
	vec2 uv_offset = centered_uv.yx / curvature;
	vec2 warped_uv = centered_uv + centered_uv * uv_offset * uv_offset;
	
    // 2. Cutoff the edges (creates the black rounded corners)
	float cutoff = step(abs(warped_uv.x), 1.0) * step(abs(warped_uv.y), 1.0);
	
    // 3. Moving Scanlines
    // Added TIME to make them drift slightly and a small flicker
	float scanline_val = sin(warped_uv.y * 200.0 + TIME * 5.0);
	vec3 scanlines = vec3(scanline_val * 0.05 + 0.95);
    
    // 4. Sample screen with Chromatic Aberration (RGB shift)
    vec2 final_uv = (warped_uv + 1.0) / 2.0;
    float r = textureLod(screen_texture, final_uv + vec2(0.001, 0.0), 0.2).r;
    float g = textureLod(screen_texture, final_uv, 0.2).g;
    float b = textureLod(screen_texture, final_uv - vec2(0.001, 0.0), 0.2).b;
	
	vec3 screen_color = vec3(r, g, b) * cutoff * scanlines;
    
    // 5. Vignette (darken corners)
	vec3 vignette = vec3(length(pow(abs(centered_uv), vec2(4.0)) / 3.0));
	screen_color -= vignette * vignette_multiplier;
    
	COLOR = vec4(screen_color, 1.0);
}