#version 440

uniform vec4 Pos;
uniform mat4 m_m,m_pvm, m_p, m_view;
uniform vec4 LOOKAT, POS;


in vec3 init_v[];

//out vec2 texCoordTC[];
patch out vec4 colorTC;
patch out vec3 init_tc;
patch out float lDetail;


layout( vertices = 16 ) out;


vec4 dir = LOOKAT - POS;
vec3 forward = normalize(dir.xyz);
vec3 start = vec3(0,0,1);
float angle = atan(forward.z, forward.x);
mat3 rotationMatrix = mat3(
    cos(angle), 0, sin(angle),
    0, 1, 0,
    -sin(angle), 0, cos(angle)
);


void main() {
    gl_out[gl_InvocationID].gl_Position = gl_in[0].gl_Position;

	vec4 viewSpacePos =  m_m * m_view * ((gl_in[0].gl_Position) + POS);
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
		distanceColor = vec4(1.0, 0.0, 1.0, 1.0);
        tessLevel = 1.0;  
		outer = 1.0;
    }
	
	colorTC= distanceColor;
	

    init_tc = init_v[0];
	lDetail = tessLevel;

    gl_TessLevelOuter[0] = outer;
    gl_TessLevelOuter[1] = outer;
    gl_TessLevelOuter[2] = outer;
    gl_TessLevelOuter[3] = outer;
    gl_TessLevelInner[0] = tessLevel;
    gl_TessLevelInner[1] = tessLevel;
}