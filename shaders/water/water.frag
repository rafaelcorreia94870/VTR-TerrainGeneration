#version 440

uniform float shininess = 128;
uniform sampler2D ocean, lake;
uniform float timer;
uniform mat4 m_view;
uniform mat4 m_view_model;
uniform vec4 l_dir;
uniform float speedvar;

in	vec3 eye;
in vec2 texCoord;

out vec4 colorOut;

void main() {

    float speed = 0.00008* speedvar;

    vec3 normal = texture(ocean, texCoord + timer * speed ).rgb;
    vec3 normal2 = texture(lake, texCoord + timer * speed ).rgb;

    vec3 l_dirCamera = normalize(vec3((-l_dir))); // camera space

    //vec3 n = mix(normal, normal2, 0.5);

    // set the specular term to an ocean blue color

    vec4 waterColor = vec4(0.0, 0.0, 0.5, 1.0);
    vec4 specularColor = vec4(0.);

    // normalize both input vectors
    vec3 nn = normalize(normal2);
    vec3 e = normalize(eye);

    float intensity = max(dot(nn,l_dirCamera), 0.0);
    float specInt = 0;
    // if the vertex is lit compute the specular color
    if (intensity > 0.0) {
        vec3 ne = normalize(-e);
        vec3 h = normalize(l_dirCamera + ne);

        float s = max(0.0, dot(h,nn));
        specInt= pow(s,shininess);
    }

    colorOut = max(intensity, 0.3) * waterColor + specularColor* specInt;
    colorOut.a = 0.8;
}