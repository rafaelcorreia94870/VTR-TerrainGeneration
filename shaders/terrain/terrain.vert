#version 440

uniform mat4 m_pvm, m_view;

in vec4 position;
in vec4 normal;
in vec2 texCoord0;

out vec4 posV;
out vec4 normalV;
out vec2 texCoordV;
out float isInsideFrustum;


void main(void) {

vec4 clipPos = m_pvm * position;

    isInsideFrustum = 1.0;
    if (clipPos.x < -clipPos.w ||
    clipPos.x > clipPos.w ||
    clipPos.y < -clipPos.w ||
    clipPos.y > clipPos.w ||
    clipPos.z < -clipPos.w ||
    clipPos.z > clipPos.w) {
        isInsideFrustum = 0.0;
    }

    posV =  position;

	normalV = normal;

    texCoordV = texCoord0;

}

