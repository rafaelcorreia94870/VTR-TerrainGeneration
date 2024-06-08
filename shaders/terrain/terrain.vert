
uniform mat4 m_pvm, m_view, m_m;
uniform mat3 m_normal;
uniform vec4 l_dir;
uniform float timer;
uniform vec4 LOOKAT;

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
	
    worldSpace.y = fbm(worldSpace.xz);
    worldSpace = translate_to_centerCam(worldSpace);
    posV = worldSpace;
    gl_Position = worldSpace;

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

