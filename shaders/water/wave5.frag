#version 410



in Data {
	vec3 normal;
	vec3 lightDir;
	vec4 eye;
} DataIn;

out vec4 colorOut;
uniform mat3 m_normal;

uniform vec4 diffuse;
uniform mat4 m_pv, m_view;

void main() {

	
	vec4 spec = vec4(0.0);
	vec3 n = normalize((m_view*vec4(DataIn.normal,0.0)).xyz);
	vec3 e = normalize(vec3(DataIn.eye)); //TO DO: add eye position
	vec3 l = normalize(DataIn.lightDir);

	float intensity = max(dot(n,l), 0.0);

	if (intensity > 0.0) {
		vec3 h = normalize(l + e);	
		float intSpec = max(dot(h,n), 0.0);
		spec = vec4(1) * pow(intSpec,256);
	}

	float diffuseIntensity = max(dot(n,l), 0.0);

	vec4 waterColor = vec4(0.3, 0.3, 1.0, 1.0);
	colorOut =  (max(intensity *  diffuse, 0.25 * diffuse))*waterColor + spec;
	colorOut.a = 0.8;

}