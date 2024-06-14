#version 440

layout(vertices = 3) out;

in vec3 eye[];
in vec2 texCoord[];
in float terrainHeight[];
in float waterHeight[];
in vec4 water_position[];
in vec3 posV[];


out vec3 pos_TC[];
out float distance_TC[];
out vec3 eye_TC[];
out vec2 texCoord_TC[];
out float terrainHeight_TC[];
out float waterHeight_TC[];
out vec4 water_position_TC[];

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
	pos_TC[gl_InvocationID] = posV[gl_InvocationID];
	eye_TC[gl_InvocationID] = eye[gl_InvocationID];
	texCoord_TC[gl_InvocationID] = texCoord[gl_InvocationID];
	terrainHeight_TC[gl_InvocationID] = terrainHeight[gl_InvocationID];
	waterHeight_TC[gl_InvocationID] = waterHeight[gl_InvocationID];
	water_position_TC[gl_InvocationID] = water_position[gl_InvocationID];



	vec4 viewSpacePos = m_view * vec4(posV[gl_InvocationID],1.0) ;
	float distanceCalc = -viewSpacePos.z /  viewSpacePos.w;
	
	float tessLevel = 3.0;
	float outer = level*5.0;
	float spacing = 50;
	
	if (distanceCalc < spacing){
		tessLevel = level*16.0;
		distance_TC[gl_InvocationID] = 1.0;

	}
	else if (distanceCalc < 2*spacing) {
        tessLevel = level*8.0;  
		distance_TC[gl_InvocationID] = 2.0;

    } else if (distanceCalc < 4 * spacing) {
        tessLevel = level*4.0;  
		distance_TC[gl_InvocationID] = 16.0;

    }
	
	
	
	if (gl_InvocationID == 0) {
		gl_TessLevelOuter[0] = outer;
		gl_TessLevelOuter[1] = outer;
		gl_TessLevelOuter[2] = outer;
		gl_TessLevelInner[0] = tessLevel;
	}
}