
in vec4 position;

uniform mat4 PVM, M, V, P;



void main(void) {
	vec4 pos = M * position;

	
	pos = translate_to_centerCam(pos);
	pos.y = fbm(pos.xz, vec4(0.0, 0.0, 0.0, 0.0));
	gl_Position = P * V * pos;
}
