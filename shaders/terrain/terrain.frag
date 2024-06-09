
uniform sampler2D grass_diff, grass_disp, grass_rough;
uniform mat4 m_pvm;
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

out vec4 color;

vec4 biomePicker(vec3 p) {
	vec4 water = vec4(0.0, 0.0, 1.0, 1.0);
	vec4 sand = vec4(0.93, 0.79, 0.69, 1.0);
	vec4 grass = vec4(0.188, 0.388, 0.165, 1.0);
	vec4 rock = vec4(0.176, 0.173, 0.173,1.0);
	vec4 snow = vec4(1.0, 1.0, 1.0, 1.0);
	vec4 dirt = vec4(0.522, 0.31, 0.149, 1.0);

	float terrainHeight = p.y;
	float maxHeight = 50;
	float waterHeight = height;

	if (terrainHeight < waterHeight) {
		return mix(sand, dirt, smoothstep(waterHeight , waterHeight + 0.1* maxHeight, terrainHeight));
	}
	else if (terrainHeight < waterHeight + 0.2* maxHeight) {
		return mix(dirt, grass, smoothstep(waterHeight - 0.01* maxHeight, waterHeight + 0.2* maxHeight, terrainHeight));
	}
	else if (terrainHeight < waterHeight + 0.4*maxHeight) {
		return mix(grass, rock, smoothstep(waterHeight + 0.2* maxHeight, waterHeight + 0.4*maxHeight, terrainHeight));
	}
	else if (terrainHeight < waterHeight + 0.9* maxHeight) {
		return mix(rock, snow, smoothstep(waterHeight + 0.6*maxHeight, waterHeight + 0.9* maxHeight, terrainHeight));
	}
	else {
		return snow;
	}
}





void main(){
	/*
	if (DataIn.isInsideFrustumTE == 0.0) {
		discard;
	}
	*/
	
	vec4 eColor = vec4(texture(grass_diff, DataIn.tcTE).xyz,1.0);

	//float eSpec = texture(grass_disp,DataIn.tcTE);.r;
	vec4 eNight = texture(grass_rough, DataIn.tcTE);

	float OFFSET = DataIn.distanceTE*0.00005;
	vec4 biome = vec4(0.0,0.0,0.0,1.0);
	vec3 p = DataIn.posTE;
	//p.y = fbm(vec2(p.x,p.z));

	//Calculate the normal of the terrain by sampling Nearby points
	vec3 front_Height = vec3 (0+OFFSET,fbm(vec2(p.x+OFFSET,p.z), biome),0);
  	vec3 right_Height = vec3 (0,fbm(vec2(p.x,p.z+OFFSET), biome),0+OFFSET);
	vec3 back_Height = vec3 (0-OFFSET,fbm(vec2(p.x-OFFSET,p.z), biome),0);
	vec3 left_Height = vec3 (0,fbm(vec2(p.x,p.z-OFFSET),biome),0-OFFSET);

  	vec3 calcNormal = cross((0,p.y,0)-left_Height,(0,p.y,0)-back_Height)+cross((0,p.y,0)-right_Height,(0,p.y,0)-front_Height);
	vec3 n = normalize(m_normal * calcNormal);
	vec3 l = normalize(DataIn.l_dirTE);
	float intensity = max(dot(l,n),0.0);

	vec4 biomeColor = biomePicker(p);
	vec4 rgbcolor = seeTessLevels == 1 ? DataIn.colorTE : biomeColor;
	if (intensity < 0.1) {
		
		color = (rgbcolor * intensity) + rgbcolor * 0.2;
	}
	else {
		color = rgbcolor * intensity ;
	}

/*
	if (DataIn.colorTE == vec4(1.0,0.0,0.0,1.0) || DataIn.colorTE == vec4(0.0,1.0,0.0,1.0) || DataIn.colorTE == vec4(0.0,0.0,1.0,1.0)){
		color = DataIn.colorTE;
	}
	else {
		color = vec4(0.0,0.0,0.0,0.0);
	}
*/
	//color = DataIn.colorTE;

	//color = clamp(eColor,0,1);


	//color = DataIn.colorTE;
	//color = vec4(2.0, 0.0, 0.0, 1.0);
}
