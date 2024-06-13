#version 440

uniform sampler2DShadow shadowMap1,shadowMap2,shadowMap3,shadowMap4;
uniform sampler2D ;
// uniform float split[4];
uniform float split1,split2,split3, split4;
uniform mat4 lightSpaceMat1,lightSpaceMat2,lightSpaceMat3,lightSpaceMat4;

in vec4 viewSpacePos;

in vec4 projShadowCoord[4];
in vec3 normalV, lightDir;

out vec4 outColor;

void main()
{
	vec4 color = vec4(0.4);
	vec4 diffuse = vec4(0.0, 0.0, 0.0, 1.0);
		
	vec3 n = normalize (normalV);

	float NdotL = max (dot (n, lightDir), 0.0);
	
	if (NdotL > 0.0) {
//		color += diffuse * NdotL;
	
		
		float split[4];
		split[0] = 100;
		split[1] = 200;
		split[2] = 400;
		split[3] = 1000;	
	
		float distance = -viewSpacePos.z /  viewSpacePos.w;
		
		vec4 p = projShadowCoord[1];

		float f1= textureProj(shadowMap1, projShadowCoord[0]);
		float f2= textureProj(shadowMap2, projShadowCoord[1]);
		float f3= textureProj(shadowMap3, projShadowCoord[2]);
		float f4= textureProj(shadowMap4, projShadowCoord[3]);

		for (int i = 0; i < 4; i++) {
			if (distance < split[i]) {
 				if (i == 0) {
					color += diffuse * (NdotL * textureProj(shadowMap1, projShadowCoord[0]));
				}
				else if (i == 1){
					color += diffuse * (NdotL * textureProj(shadowMap2, projShadowCoord[1]));
				}
				else if (i == 2) {
					color += diffuse * NdotL * f3;
				}
				else if (i == 3) {
					color += diffuse * NdotL * f4;
				}
				break;		

			}
		}
	}

	outColor = color;	
}
