
in vec4 position;

uniform mat4 PVM, M, V, P;
uniform int shadows;
uniform sampler2D biome_map;
uniform float biome_scale_on_terrain;

out vec4 posV;


void main(void) {
	if(shadows == 0) {
		gl_Position = PVM * position;
		return;
	}
	vec4 pos = M * position;

	pos = translate_to_centerCam(pos);
	vec4 biomeColor = biomeColor(pos.xyz, biome_map, biome_scale_on_terrain);
	pos.y = pattern(pos.xz, biomeColor);
	posV = pos;
}
