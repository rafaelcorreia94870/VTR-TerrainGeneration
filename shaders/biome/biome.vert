#version 460

uniform float bm_scale;

in vec4 position;
in vec2 texCoord0;

out vec2 tc;

void main() {
    tc = texCoord0*bm_scale;
    gl_Position = position;

}