#version 440

uniform	mat4 m_pvm;
uniform mat4 m_m;
uniform	mat4 m_vm;
uniform	mat4 m_view;
uniform mat4 m_p;
uniform	mat3 m_normal;
uniform mat4 m_view_model;
uniform float height;


uniform	vec4 l_dir;	   // global space

in vec4 position;	// local space
in vec3 normal;		// local space
in vec2 texCoord0;

// the data to be sent to the fragment shader

out vec3 eye;
out vec2 texCoord;

void main () {
	texCoord = texCoord0;
	eye =  vec3(m_view_model * position);
	vec4 calcposition = m_m * position;
	calcposition.y = height;
    gl_Position = m_p* m_view * calcposition;
}