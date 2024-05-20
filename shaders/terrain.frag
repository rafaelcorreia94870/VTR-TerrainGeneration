#version 440

in Data {
	vec3 normalTE;
	vec3 l_dirTE;
	vec4 colorTE;
	vec2 tcTE;
	float eTE;
} DataIn;

out vec4 color;

void main(){
	vec3 n = normalize(DataIn.normalTE);
	vec3 l = normalize(DataIn.l_dirTE);
	float intensity = max(dot(l,n),0.0);
	if (intensity < 0.1) {
		color = (DataIn.colorTE * intensity) + DataIn.colorTE * 0.2;
	}
	else {
		color = DataIn.colorTE * intensity;
	}
}