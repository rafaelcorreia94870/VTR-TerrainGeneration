#version 440

in vec4 position;
in vec4 normal;
in vec2 texCoord0;

out vec4 posV;
out vec4 normalV;
out vec2 texCoordV;

void main(void) {

    posV =  position;

	normalV = normal;

    texCoordV = texCoord0;
}

