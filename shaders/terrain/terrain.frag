#version 440

uniform sampler2D grass_diff, grass_disp, grass_rough;
uniform mat4 m_pvm;

in Data {
	vec3 normalTE;
	vec3 l_dirTE;
	vec4 colorTE;
	vec2 tcTE;
	float eTE;
} DataIn;

out vec4 color;

void main(){
	/*
	if (DataIn.isInsideFrustumTE == 0.0) {
		discard;
	}
	*/
	
	vec4 eColor = vec4(texture(grass_diff, DataIn.tcTE).xyz,1.0);

	//float eSpec = texture(grass_disp,DataIn.tcTE);.r;
	vec4 eNight = texture(grass_rough, DataIn.tcTE);


	vec3 n = normalize(DataIn.normalTE);
	vec3 l = normalize(DataIn.l_dirTE);
	float intensity = max(dot(l,n),0.0);
	if (intensity < 0.1) {
		
		color = (DataIn.colorTE * intensity) + DataIn.colorTE * 0.2;
	}
	else {
		color = DataIn.colorTE * intensity ;
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
