
uniform mat4 m_pvm, m_view, m_m, m_p;
uniform mat3 m_normal;
uniform vec4 l_dir;
uniform float timer;
uniform vec4 LOOKAT;
uniform sampler2D biome_map;
uniform float biome_scale_on_terrain;

in vec4 position;
in vec3 normal;
in vec2 texCoord0;

out vec4 posV;
out vec3 normalV;
out vec2 texCoordV;
out float isInsideFrustum;


void main(void) {
    vec4 dir = LOOKAT - POS;
    vec4 worldSpace = m_m * vec4(position.x,0,position.z,1.);


    float height = 0.0;

	float amplitude = 1.0;
	float frequency = 1.0;
	
    worldSpace = translate_to_centerCam(worldSpace);
    vec4 biome = biomeColor(worldSpace.xyz, biome_map, biome_scale_on_terrain);
    worldSpace.y = pattern(worldSpace.xz, biome);
    posV = worldSpace;
    gl_Position = m_p * m_view * worldSpace;

    /* vec4 clipPos = m_pvm * position;

    isInsideFrustum = 1.0;
    if (clipPos.x < -clipPos.w ||
        clipPos.x > clipPos.w ||
        clipPos.y < -clipPos.w ||
        clipPos.y > clipPos.w ||
        clipPos.z < -clipPos.w ||
        clipPos.z > clipPos.w) {
        isInsideFrustum = 0.0;
    } */


	normalV = normal;

    texCoordV = texCoord0;

}

