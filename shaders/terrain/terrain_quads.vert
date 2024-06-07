#version 440


uniform float FOV, NEAR, FAR;
uniform int squareSize;
uniform int chunkSize;
uniform mat4 m_m;
uniform vec4 LOOKAT;
uniform vec4 POS;




out vec3 init_v;


//32x32 = 1024
int sqrootInstances = 32;
void main () {

	vec4 dir = LOOKAT - POS;
	dir.y= 0;
	vec4 pos;


	float windowWidth = (2*tan(FOV/2.0)) * (NEAR-FAR);
	pos.x = ((gl_InstanceID ) % int(sqrootInstances))*chunkSize*squareSize;// - (12*chunkSize*squareSize);
	pos.z = ((gl_InstanceID ) / int(sqrootInstances))*chunkSize*squareSize;// - (12*chunkSize*squareSize);
	pos.y= 0;
	pos.w = 1;

	init_v = pos.xyz;


    gl_Position = pos;
}