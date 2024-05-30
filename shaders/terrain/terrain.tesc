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

uniform vec4 Pos;
uniform mat4 m_m, m_view;
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

	vec4 viewSpacePos = m_m * m_view * posV[gl_InvocationID] ;
	float distanceCalc = -viewSpacePos.z /  viewSpacePos.w;
	
	float tessLevel = 3.0;
	float outer = 3.0;
	float spacing = 10;
	vec4 distanceColor = vec4(1.0, 1.0, 1.0, 1.0);
	
	if (distanceCalc < spacing){
		distanceColor = vec4(1.0, 1.0, 1.0, 1.0);
		tessLevel = 20.0;
		outer = 20.0;
	}
	else if (distanceCalc < 3*spacing) {
		distanceColor = vec4(1.0, 0.0, 0.0, 1.0);
		outer= 20.0;
        tessLevel = 10.0;  
    } else if (distanceCalc < 5 * spacing) {
		distanceColor = vec4(0.0, 1.0, 0.0, 1.0);
		outer = 3.0;
        tessLevel = 3.0;  
    } else {
		distanceColor = vec4(0.0, 0.0, 1.0, 1.0);
        tessLevel = 1.0;  
		outer = 1.0;
    }
	
	colorTC[gl_InvocationID] = distanceColor;
	
	if (gl_InvocationID == 0) {
		gl_TessLevelOuter[0] = outer;
		gl_TessLevelOuter[1] = outer;
		gl_TessLevelOuter[2] = outer;
		gl_TessLevelInner[0] = tessLevel;
	}
}