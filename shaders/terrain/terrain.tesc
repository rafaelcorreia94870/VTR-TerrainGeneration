#version 440

layout(vertices = 3) out;

in vec4 posV[];
in vec3 normalV[];
in vec2 texCoordV[];
in float isInsideFrustum[];


out vec4 posTC[];
out vec3 normalTC[];
out vec2 texCoordTC[];
out vec4 colorTC[];
out float isInsideFrustumTC[];
out float distanceTC[];

uniform vec4 Pos;
uniform mat4 m_m, m_view, m_p;
uniform float olevel=10;
uniform float ilevel=10;

void main() {
	isInsideFrustumTC[gl_InvocationID] = isInsideFrustum[gl_InvocationID];
	
	/*
	if (isInsideFrustum[gl_InvocationID] == 0.0) {
		gl_TessLevelOuter[0] = 1.0;
		gl_TessLevelOuter[1] = 1.0;
		gl_TessLevelOuter[2] = 1.0;
		gl_TessLevelInner[0] = 1.0;
		return;
	}
	*/

	posTC[gl_InvocationID] = posV[gl_InvocationID];
	normalTC[gl_InvocationID] = normalV[gl_InvocationID];
	texCoordTC[gl_InvocationID] = texCoordV[gl_InvocationID];

	vec4 viewSpacePos = m_view * posV[gl_InvocationID] ;
	float distanceCalc = -viewSpacePos.z /  viewSpacePos.w;
	
	float tessLevel = 3.0;
	float outer = 20.0;
	float spacing = 5;
	vec4 distanceColor = vec4(1.0, 1.0, 1.0, 1.0);
	
	if (distanceCalc < spacing){
		distanceColor = vec4(0.604, 0.388, 0.141,1.0);
		tessLevel = 45.0;
		distanceTC[gl_InvocationID] = 1.0;

	}
	else if (distanceCalc < 2*spacing) {
		distanceColor = vec4(0.749, 0.937, 0.271,1.0);
        tessLevel = 32.0;  
		distanceTC[gl_InvocationID] = 1.0;

    } else if (distanceCalc < 4 * spacing) {
		distanceColor = vec4(0.98, 0.745, 0.831,1.0);
        tessLevel = 16.0;  
		distanceTC[gl_InvocationID] = 2.0;

    } else if(distanceCalc < 8 * spacing) {
		distanceColor = vec4(1., 0.882, 0.098,1.0);
        tessLevel = 8.0;  
		distanceTC[gl_InvocationID] = 4.0;

    }
	else if (distanceCalc < 16 * spacing) {
		distanceColor = vec4(0.569, 0.118, 0.706,1.0);
		tessLevel = 4.0;  
		distanceTC[gl_InvocationID] = 512.0;

	} else if (distanceCalc < 32 * spacing){
		distanceColor = vec4(0.961, 0.51, 0.192,1.0);
		tessLevel = 2.0;  
		distanceTC[gl_InvocationID] = 2048;
	}
	else{
		distanceColor = vec4(0.502, 0.502, 0.0,1.0);
		tessLevel = 1.0;
		distanceTC[gl_InvocationID] = 4096;

	}
	
	colorTC[gl_InvocationID] = distanceColor;
	
	if (gl_InvocationID == 0) {
		gl_TessLevelOuter[0] = outer;
		gl_TessLevelOuter[1] = outer;
		gl_TessLevelOuter[2] = outer;
		gl_TessLevelInner[0] = tessLevel;
	}
}