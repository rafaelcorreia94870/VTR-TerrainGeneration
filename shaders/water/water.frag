float shininess = 32;
uniform sampler2D ocean, waves, water, foam;
uniform float timer;
uniform mat4 m_view, m_p;
uniform mat4 m_view_model;
uniform vec4 l_dir;
uniform mat3 m_normal;
uniform float speedvar;
uniform int foam_option;
uniform int shadows;
uniform sampler2DShadow shadowMap1,shadowMap2,shadowMap3,shadowMap4;
uniform mat4 lightSpaceMat1,lightSpaceMat2,lightSpaceMat3,lightSpaceMat4;

/* in Data {
    vec3 normalTE;
	vec3 l_dirTE;
    vec2 tcTE;
    vec3 eTE;
	vec3 posTE;
	float distanceTE;
	vec2 texCoordTE;
	float waterHeightTE;
	float terrainHeightTE;
} DataIn; */


in vec3 eye;
in vec2 texCoord;
in float terrainHeight;
in float waterHeight;
in vec4 water_position;
in vec3 posV;
/* in vec3 posTE;
in vec3 eye;
in vec2 texCoord;
in float terrainHeight;
in float waterHeight;
in vec4 water_position; */

out vec4 colorOut;

void main() {
    //float terrainHeight = DataIn.terrainHeightTE;
    //float waterHeight = DataIn.waterHeightTE;
    //vec2 texCoord = DataIn.tcTE;



    float speed = 0.00008* speedvar;
    vec3 normal = texture(ocean, texCoord + timer * speed ).rgb;
    vec3 normal2 = texture(water, texCoord - 0.5 * timer * speed ).rgb;
    //vec3 normal3 = texture(lake, vec2(texCoord.r - 0.5 * timer * speed, texCoord.g * timer * 1/speed)).rgb;
    //vec3 n = mix(normal, mix(normal2, normal3, 0.5), 0.5);
    vec3 n = mix(normal, normal2, 0.5);
    vec3 nn = normalize(m_normal* n);

    vec3 l_dirCamera = normalize(vec3(m_view * (-l_dir))); // camera space


    // set the specular term to an ocean blue color
    vec4 color;
    vec4 waterColor = vec4(0.0, 0.4, 0.7, 1.0);
    waterColor = vec4(0.137, 0.537, 0.855,1.0);
    vec4 specularColor = vec4(0.0, 0.0, 0.0, 1.0);

    // normalize both input vectors


    float intensity = max(dot(nn,l_dirCamera), 0.0);
    float specInt = 0;
    if (intensity > 0.0) {
        
        //vec3 eye = DataIn.eTE;
        vec3 ne = normalize(-eye);
        vec3 h = normalize(l_dirCamera + ne);

        float s = max(0.0, dot(h,ne));
        specInt = pow(s,shininess);
    }
    vec4 baseColor =  max(intensity *  waterColor + specularColor * specInt, waterColor * 0.35);
    baseColor = intensity * waterColor + specularColor * specInt;
    color = baseColor;
    if (foam_option == 0) {
        float foamFactor = texture(foam, texCoord * 10.0 + vec2(timer * speed * .1, timer * speed * 0.1)).r;
        vec4 foamColor = vec4(foamFactor, foamFactor, foamFactor, 1.0);
        foamColor = mix(baseColor, vec4(1.0), foamFactor);
        
        if (terrainHeight >= waterHeight - 3.0) {
            float blendFactor = smoothstep(waterHeight - 3.0, waterHeight, terrainHeight);
            color = mix(baseColor, foamColor, blendFactor);
        } else {
            color = baseColor;
        }
    }

    

	if(shadows == 1){

    	vec3 lightDir = l_dirCamera;
        vec3 p = posV;
    	float NdotL = max(dot(n, lightDir), 0.0);

    	vec4 viewSpacePos = m_view * vec4(posV, 1.0);
    	float distance = -viewSpacePos.z / viewSpacePos.w;
    	vec4 projShadowCoord[4];
    	float split[4];
		colorOut = color;



    	if (shadows==1) {
    	    split[0] = 100;
    	    split[1] = 200;
    	    split[2] = 400;
    	    split[3] = 2000;

			projShadowCoord[0] = lightSpaceMat1  * vec4(p, 1.0);
			projShadowCoord[1] = lightSpaceMat2  * vec4(p, 1.0);
			projShadowCoord[2] = lightSpaceMat3  * vec4(p, 1.0);
			projShadowCoord[3] = lightSpaceMat4  * vec4(p, 1.0);

	
    	    float shadowFactor[4];
    	    shadowFactor[0] = textureProj(shadowMap1, projShadowCoord[0]).r;
    	    shadowFactor[1] = textureProj(shadowMap2, projShadowCoord[1]).r;
    	    shadowFactor[2] = textureProj(shadowMap3, projShadowCoord[2]).r;
    	    shadowFactor[3] = textureProj(shadowMap4, projShadowCoord[3]).r;

			float shadow = 0.0;
			for (int i = 0; i < 4; i++) {
				if (distance < split[i]) {
				shadow = shadowFactor[i];
				break;
				}
			}

			color = color * (shadow) + color * 0.4;
			colorOut = color;
    	}
	}
	else {
		colorOut = color;
	}

    colorOut.a = 0.9;
    //colorOut = vec4(1.0,0.0,0.0, 1.0);
    
}