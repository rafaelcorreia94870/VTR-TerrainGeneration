#version 410
uniform mat4 m_vm, m_view, m_pvm, m_m;
uniform mat3 m_normal;
uniform vec4 l_dir;

in vec4 position;
in vec3 normal;
in vec2 texCoord0;


out Data {
	vec3 normal;
	vec3 lightDir;
	//vec2 tc;

} DataOut;

void main() {
    DataOut.lightDir = vec3(m_view * (-l_dir));
	DataOut.normal = normalize(normal); 
	//DataOut.tc = texCoord0;
    gl_Position = position ;
}



