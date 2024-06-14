
in vec4 position;

uniform mat4 PVM, M, V, P;
uniform int shadows;


out vec4 posV;


void main(void) {
	if(shadows == 0) {
		gl_Position = PVM * position;
		return;
	}
	vec4 pos = M * position;

	
	pos = translate_to_centerCam(pos);
	pos.y = fbm(pos.xz, vec4(0.0, 0.0, 0.0, 0.0));
	posV = pos;
}
