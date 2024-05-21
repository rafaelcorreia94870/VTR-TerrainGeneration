#version 440

uniform sampler2D grass_diff, grass_disp, grass_rough;

in Data {
	vec3 normalTE;
	vec3 l_dirTE;
	vec4 colorTE;
	vec2 tcTE;
	float eTE;
} DataIn;

out vec4 color;

void main(){
	

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
	

	//color = clamp(eColor,0,1);


	//color = DataIn.colorTE;
	//color = vec4(2.0, 0.0, 0.0, 1.0);
}
