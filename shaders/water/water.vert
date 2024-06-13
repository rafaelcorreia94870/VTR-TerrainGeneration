
uniform	mat4 m_pvm;
uniform mat4 m_m;
uniform	mat4 m_vm;
uniform	mat4 m_view;
uniform mat4 m_p;
uniform	mat3 m_normal;
uniform mat4 m_view_model;
uniform sampler2D water;
uniform float timer;
uniform float speedvar;




uniform	vec4 l_dir;	   // global space

in vec4 position;	// local space
in vec3 normal;		// local space
in vec2 texCoord0;

// the data to be sent to the fragment shader

out vec3 eye;
out vec2 texCoord;
out float terrainHeight;
out float waterHeight;
out vec4 water_position;

void main () {
    float speed = 0.00008* speedvar;

	texCoord = texCoord0;
	eye =  vec3(m_view_model * position);


	vec4 calcposition = m_m * position;
	calcposition.y = height;
	calcposition.y += texture(water, texCoord - 0.5 * timer * speed).r;
	calcposition = translate_to_centerCam(calcposition);

	vec4 biome = vec4(0.0, 0.0, 0.0, 0.0);
    terrainHeight = fbm(vec2(calcposition.x, calcposition.z), biome);
	waterHeight = calcposition.y;
	water_position = calcposition;


    gl_Position = m_p* m_view * calcposition;

}