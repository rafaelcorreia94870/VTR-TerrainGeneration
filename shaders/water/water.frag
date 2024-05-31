#version 440

float shininess = 64;
uniform sampler2D ocean, lake, waves;
uniform float timer;
uniform mat4 m_view;
uniform mat4 m_view_model;
uniform vec4 l_dir;
uniform mat3 m_normal;
uniform float speedvar;

in	vec3 eye;
in vec2 texCoord;

out vec4 colorOut;

void main() {

    float speed = 0.00008* speedvar;
    vec3 normal = texture(ocean, texCoord + timer * speed ).rgb;
    vec3 normal2 = texture(lake, texCoord - 0.5 * timer * speed ).rgb;
    vec3 normal3 = texture(lake, vec2(texCoord.r - 0.5 * timer * speed, texCoord.g * timer * 1/speed)).rgb;
    vec3 n = mix(normal, mix(normal2, normal3, 0.5), 0.5);
    vec3 nn = normalize(m_normal* n);

    vec3 l_dirCamera = normalize(vec3(m_view * (-l_dir))); // camera space


    // set the specular term to an ocean blue color

    vec4 waterColor = vec4(0.0, 0.4, 0.7, 1.0);
    vec4 specularColor = vec4(1.0, 1.0, 1.0, 1.0);

    // normalize both input vectors


    float intensity = max(dot(nn,l_dirCamera), 0.0);
    float specInt = 0;
    if (intensity > 0.0) {
        
        vec3 ne = normalize(-eye);
        vec3 h = normalize(l_dirCamera + ne);

        float s = max(0.0, dot(h,nn));
        if (s == 0){
           // waterColor = vec4(1.0, 0.2,0.1,1.0);
        }
        specInt= pow(s,shininess);
    }

    colorOut = max(intensity, 0.2) * waterColor + specularColor * specInt;
    colorOut.a = 0.8;
}