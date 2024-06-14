layout(triangles, fractional_odd_spacing, ccw) in;

uniform	mat4 m_pvm, m_view, m_p, m_m;
uniform	mat3 m_normal;
uniform vec4 l_dir;
uniform float timer;
uniform int shadows;

float minValue = 2;
float maxValue = 400;


in vec3 pos_TC[];
in float distance_TC[];
in vec3 eye_TC[];
in vec2 texCoord_TC[];
in float terrainHeight_TC[];
in float waterHeight_TC[];
in vec4 water_position_TC[];

out Data {
    vec3 normalTE;
	vec3 l_dirTE;
    vec2 tcTE;
    vec3 eTE;
	vec3 posTE;
	float distanceTE;
	vec2 texCoordTE;
	float waterHeightTE;
	float terrainHeightTE;
} DataOut;


void main() {
	if(shadows == 0){
		return;
	}

	vec3 b300 = (pos_TC[0]);
	vec3 b030 = (pos_TC[1]);
	vec3 b003 = (pos_TC[2]);
	


	
	vec3 n1 = vec3(0,1,0);
	
	vec3 b300b003 = b003 - b300;
	vec3 b300b030 = b030 - b300;

	
	
	vec3 n2 = vec3(0,1,0);
	
	vec3 b030b300 = b300 - b030;
	vec3 b030b003 = b003 - b030;


	vec3 n3 = vec3(0,1,0);
	

	vec3 b003b030 = b030 - b003;
	vec3 b003b300 = b300 - b003;

	



	n1 = normalize(n1);
	n2 = normalize(n2);
	n3 = normalize(n3);
	
	float w12 = dot (b030 - b300, n1);
	float w21 = dot (b300 - b030, n2);
	
	float w13 = dot (b003 - b300, n1);
	float w31 = dot (b300 - b003, n3);
	
	float w23 = dot (b003 - b030, n2);
	float w32 = dot (b030 - b003, n3);
	
	vec3 b210 = (2*b300 + b030 - w12*n1) / 3 ;
	vec3 b120 = (2*b030 + b300 - w21*n2) / 3 ;

	vec3 b021 = (2*b030 + b003 - w23*n2) / 3 ;
	vec3 b012 = (2*b003 + b030 - w32*n3) / 3 ;

	vec3 b102 = (2*b003 + b300 - w31*n3) / 3 ;
	vec3 b201 = (2*b300 + b003 - w13*n1) / 3 ;

	vec3 E = (b210 + b120 + b021 + b012 + b201 + b102) / 6;
	vec3 V = (b300 + b030 + b003) / 3;

	vec3 b111 = E + (E - V) / 2;
	
	float u = gl_TessCoord.x;
	float v = gl_TessCoord.y;                                           
	float w = gl_TessCoord.z;



	vec3 res = b300 * w*w*w + b030 * u*u*u + b003 * v*v*v +
				b210 * 3 * w*w*u + b120 * 3*w*u*u + b201 * 3 * w*w*v +
				b021 * 3*u*u*v + b102 * 3*w*v*v + b012 * 3*u*v*v +
				b111*6*w*u*v;
	//n sei
	//res.y += 2 * snoise(res.xy);

	float v12 = 2 * (dot (b030 - b300, n1+n2)/dot (b030 - b300, b030 - b300));
	float v23 = 2 * (dot (b003 - b030, n2+n3)/dot (b003 - b030, b003 - b030));
	float v31 = 2 * (dot (b300 - b003, n3+n1)/dot (b003 - b300, b003 - b300));
	
	vec3 n110 = normalize ( n1 + n2 - v12 *(b030 - b300));
	vec3 n011 = normalize ( n2 + n3 - v23 *(b003 - b030));
	vec3 n101 = normalize ( n3 + n1 - v31 *(b300 - b003));

	
	
	
	DataOut.normalTE = normalize(m_normal*
				vec3((n1 *w*w + n2 *u*u + n3 *v*v +
				n110 *w*u + n011 * u*v + n101 * w*v)));
	
	
	DataOut.l_dirTE = normalize(l_dir.xyz);
	DataOut.tcTE = texCoord_TC[0];
	DataOut.eTE = eye_TC[0];
	DataOut.posTE = res;
	DataOut.distanceTE = distance_TC[0];
	DataOut.texCoordTE = DataOut.tcTE;
	DataOut.waterHeightTE = waterHeight_TC[0];
	DataOut.terrainHeightTE = terrainHeight_TC[0];
	gl_Position =  m_p * m_view * vec4(res,1.0);
}

