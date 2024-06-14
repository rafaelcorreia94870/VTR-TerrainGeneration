#version 440

layout(vertices = 3) out;

in vec4 posV[];


out vec4 posTC[];
out float distanceTC[];

uniform vec4 Pos;
uniform mat4 m_m, m_view, m_p;
uniform float level;
uniform int shadows;


void main() {
	
	if(shadows == 0){
		gl_TessLevelOuter[0] = 0.0;
		gl_TessLevelOuter[1] = 0.0;
		gl_TessLevelOuter[2] = 0.0;
		gl_TessLevelInner[0] = 0.0;
		return;
	}
	posTC[gl_InvocationID] = posV[gl_InvocationID];

	vec4 viewSpacePos = m_view * posV[gl_InvocationID] ;
	float distanceCalc = -viewSpacePos.z /  viewSpacePos.w;
	
	float tessLevel = 3.0;
	float outer = level*10.0;
	float spacing = 50;
	
	if (distanceCalc < spacing){
		tessLevel = level*28.0;
		distanceTC[gl_InvocationID] = 1.0;

	}
	else if (distanceCalc < 2*spacing) {
        tessLevel = level*16.0;  
		distanceTC[gl_InvocationID] = 2.0;

    } else if (distanceCalc < 4 * spacing) {
        tessLevel = level*8.0;  
		distanceTC[gl_InvocationID] = 16.0;

    } else if(distanceCalc < 8 * spacing) {
        tessLevel = level*4.0;  
		distanceTC[gl_InvocationID] = 32.0;

    }
	else if (distanceCalc < 16 * spacing) {
		if(level >= 0.5)
			tessLevel = level* 2.0;
		else
			tessLevel = 1.0;  
		distanceTC[gl_InvocationID] = 512.0;

	} else if (distanceCalc < 32 * spacing){
		tessLevel = 1.0;
		tessLevel = 2.0;  
		distanceTC[gl_InvocationID] = 2048;
	}
	else{
		tessLevel = 1.0;
		distanceTC[gl_InvocationID] = 4096;

	}
	
	
	if (gl_InvocationID == 0) {
		gl_TessLevelOuter[0] = outer;
		gl_TessLevelOuter[1] = outer;
		gl_TessLevelOuter[2] = outer;
		gl_TessLevelInner[0] = tessLevel;
	}
}