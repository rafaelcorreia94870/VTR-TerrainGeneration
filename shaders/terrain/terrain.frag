
uniform sampler2D grass_diff, grass_disp, grass_rough;
uniform sampler2DShadow shadowMap1,shadowMap2,shadowMap3,shadowMap4;
uniform mat4 lightSpaceMat1,lightSpaceMat2,lightSpaceMat3,lightSpaceMat4;
uniform vec4 lightDirection;
uniform mat4 inverse_projection, inverse_view;
uniform int shadows;



uniform mat4 m_pvm, m_m, m_view, m_p;

uniform mat3 m_normal;
uniform int seeTessLevels;

in Data {
	vec3 normalTE;
	vec3 l_dirTE;
	vec4 colorTE;
	vec2 tcTE;
	float eTE;
	vec3 posTE;
	float distanceTE;
} DataIn;

out vec4 colorOut;


void main() {    
    vec4 eColor = vec4(texture(grass_diff, DataIn.tcTE).xyz, 1.0);
    vec4 eNight = texture(grass_rough, DataIn.tcTE);

    float OFFSET = DataIn.distanceTE * 0.0008;
    vec3 p = DataIn.posTE;
    //vec4 biome = vec4(0.0, 0.0, 0.0, 1.0);
	vec4 biome = biomeColor(p, biome_map, biome_scale_on_terrain);
	
    // Calculate the normal of the terrain by sampling Nearby points
    vec3 front_Height = vec3(0 + OFFSET, pattern(vec2(p.x + OFFSET, p.z), biome), 0);
    vec3 right_Height = vec3(0, pattern(vec2(p.x, p.z + OFFSET), biome), 0 + OFFSET);
    vec3 back_Height = vec3(0 - OFFSET, pattern(vec2(p.x - OFFSET, p.z), biome), 0);
    vec3 left_Height = vec3(0, pattern(vec2(p.x, p.z - OFFSET), biome), 0 - OFFSET);

    vec3 calcNormal = cross(vec3(0, p.y, 0) - left_Height, vec3(0, p.y, 0) - back_Height) + cross(vec3(0, p.y, 0) - right_Height, vec3(0, p.y, 0) - front_Height);
    vec3 n = normalize(m_normal * calcNormal);
    vec3 l = normalize(DataIn.l_dirTE);
    float intensity = max(dot(l, n), 0.0);

	vec4 color;
    vec4 biomeColor = biomePicker(p);
    vec4 rgbcolor = seeTessLevels == 1 ? DataIn.colorTE : biomeColor;
	


    if (intensity <= 0.1) {
        color = (rgbcolor * intensity) + rgbcolor * 0.2;
    } else {
        color = rgbcolor * intensity;
    }



	if(shadows == 1){

    	vec3 lightDir = normalize(vec3(m_view * -lightDirection));
    	float NdotL = max(dot(n, lightDir), 0.0);

    	vec4 viewSpacePos = m_view * vec4(DataIn.posTE, 1.0);
    	float distance = -viewSpacePos.z / viewSpacePos.w;
    	vec4 projShadowCoord[4];
    	float split[4];
		colorOut = color;



    	if (NdotL > 0.0) {
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
	
}

