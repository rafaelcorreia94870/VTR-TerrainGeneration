#version 440

in vec4 position;

uniform float FOV, NEAR, FAR;
uniform int squareSize;
uniform int chunkSize;
uniform mat4 m_m;
uniform vec4 LOOKAT;
uniform vec4 POS;
//32x32 = 1024
void main () {

	vec4 dir = LOOKAT - POS;
	dir.y= 0;
	vec4 pos;


	float windowWidth = (2*tan(FOV/2.0)) * (NEAR-FAR);
	pos.x = ((gl_InstanceID ) % int(32))*chunkSize*squareSize - (12*chunkSize*squareSize);
	pos.z = ((gl_InstanceID ) / int(32))*chunkSize*squareSize - (12*chunkSize*squareSize);
	pos.y= 0;
	pos.w = 1;

	
	//pos.xyz = (pos.xyz + POS.xyz) ;

	/*
    vec3 forward = normalize(dir.xyz);
    vec3 right = normalize(cross(forward, vec3(0.0, 1.0, 0.0)));
    vec3 up = cross(right, forward);
    mat3 rotationMatrix = mat3(right, up, forward);
	*/
/*
	vec3 forward = normalize(dir.xyz);
	vec3 start = vec3(0,0,1);

	float angle = atan(forward.z, forward.x);

	mat3 rotationMatrix = mat3(
        cos(angle), 0, sin(angle),
        0, 1, 0,
        -sin(angle), 0, cos(angle)
    );

    pos.xyz = rotationMatrix * pos.xyz;

	pos.xyz = pos.xyz + POS.xyz ;
*/
	

	pos.y = 0;
    gl_Position = pos;
}