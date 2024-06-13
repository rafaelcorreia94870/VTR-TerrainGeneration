
uniform vec4 lightDirection;
uniform mat4 lightSpaceMat1,lightSpaceMat2,lightSpaceMat3,lightSpaceMat4;
uniform mat4 PVM;
uniform mat4 V, M, P;
uniform mat3 NormalMatrix;

in vec4 position;
in vec4 normal;
in vec4 texCoord;

out vec4 viewSpacePos;
out vec4 projShadowCoord[4];
out vec3 normalV, lightDir;


void main()
{


	
	lightDir = normalize (vec3(V * -lightDirection));
	vec4 pos = M * position;

	pos = translate_to_centerCam(pos);
	pos.y = fbm(pos.xz, vec4(0.0, 0.0, 0.0, 0.0));

	float OFFSET = 0.00005;
	vec4 biome = vec4(0.0,0.0,0.0,1.0);
	vec3 p = pos.xyz;
	//p.y = fbm(vec2(p.x,p.z));

	//Calculate the normal of the terrain by sampling Nearby points
	vec3 front_Height = vec3 (0+OFFSET,fbm(vec2(p.x+OFFSET,p.z), biome),0);
  	vec3 right_Height = vec3 (0,fbm(vec2(p.x,p.z+OFFSET), biome),0+OFFSET);
	vec3 back_Height = vec3 (0-OFFSET,fbm(vec2(p.x-OFFSET,p.z), biome),0);
	vec3 left_Height = vec3 (0,fbm(vec2(p.x,p.z-OFFSET),biome),0-OFFSET);

  	vec3 calcNormal = cross((0,p.y,0)-left_Height,(0,p.y,0)-back_Height)+cross((0,p.y,0)-right_Height,(0,p.y,0)-front_Height);
	normalV = normalize (NormalMatrix * calcNormal);

	projShadowCoord[0] = lightSpaceMat1 * pos;
	projShadowCoord[1] = lightSpaceMat2 * pos;
	projShadowCoord[2] = lightSpaceMat3 * pos;
	projShadowCoord[3] = lightSpaceMat4 * pos;
	
	viewSpacePos = V * pos;
	
	gl_Position = P * V * pos;
}  