#version 440

layout(vertices = 3) out;

in vec4 posV[];
in vec4 normalV[];
in vec2 texCoordV[];

out vec4 posTC[];
out vec4 normalTC[];
out vec2 texCoordTC[];

uniform float olevel=10;
uniform float ilevel=10;

void main() {

	posTC[gl_InvocationID] = posV[gl_InvocationID];
	normalTC[gl_InvocationID] = normalV[gl_InvocationID];
	texCoordTC[gl_InvocationID] = texCoordV[gl_InvocationID];
	
	if (gl_InvocationID == 0) {
		gl_TessLevelOuter[0] = olevel;
		gl_TessLevelOuter[1] = olevel;
		gl_TessLevelOuter[2] = olevel;
		gl_TessLevelInner[0] = ilevel;
	}
}