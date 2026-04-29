shader_type canvas_item;
uniform float SPEED = .1;

void vertex() {
	UV.x -= TIME * SPEED;
	UV.y += TIME * SPEED;
}