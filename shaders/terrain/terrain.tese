
layout(triangles, fractional_odd_spacing, ccw) in;

uniform	mat4 m_pvm, m_view, m_p, m_m;
uniform	mat3 m_normal;
uniform vec4 l_dir;
uniform float timer;
uniform float scale;

uniform int num_octaves;
uniform float persistence;
uniform float lacunarity;
uniform float heightmult;
float minValue = 2;
float maxValue = 400;


in vec3 normalTC[];
in vec4 posTC[];
in vec2 texCoord[];
in vec4 colorTC[];
in float isInsideFrustumTC[];

out Data {
    vec3 normalTE;
	vec3 l_dirTE;
    vec4 colorTE;
    vec2 tcTE;
    float eTE;
	float isInsideFrustumTE;
} DataOut;


void main() {
	DataOut.isInsideFrustumTE = 1.0;
	/*
	if (isInsideFrustumTC[0]==0.0 && isInsideFrustumTC[1]==0.0 && isInsideFrustumTC[2]==0.0) {
		DataOut.isInsideFrustumTE = 0.0;
		return;
	}
	*/


    //confio só nas contas do stor
	vec3 b300 = (m_m * posTC[0]).xyz;
	vec3 b030 = (m_m * posTC[1]).xyz;
	vec3 b003 = (m_m * posTC[2]).xyz;

	float noisevar1 = 0.0;
	float noisevar2 = 0.0;
	float noisevar3 = 0.0;
	float amplitude = 1.0;
	float frequency = 1.0;
	for(int i = 0; i < num_octaves; ++i) {
		float sampleX1 = b300.x / scale * frequency;
		float sampleX2 = b030.x / scale * frequency;
		float sampleX3 = b003.x / scale * frequency;

		float sampleZ1 = b300.z / scale * frequency;
		float sampleZ2 = b030.z / scale * frequency;
		float sampleZ3 = b003.z / scale * frequency;
		
        noisevar1 += (snoise(vec2(sampleX1,sampleZ1))) * amplitude;
		noisevar2 += (snoise(vec2(sampleX2,sampleZ2))) * amplitude;
		noisevar3 += (snoise(vec2(sampleX3,sampleZ3))) * amplitude;

		amplitude *= persistence;
		frequency *= lacunarity;
    }
	b300.y += heightmult * noisevar1;
	b030.y += heightmult * noisevar2;
	b003.y += heightmult * noisevar3;



	//float noisevarmix = (noisevar1 + noisevar2 + noisevar3) / 3;
	//DataOut.colorTE = vec3(noisevarmix, noisevarmix, noisevarmix, 1.0);
	
	vec3 n1 = normalTC[0].xyz;
	/*
	vec3 b300b003 = b003 - b300;
	vec3 b300b030 = b030 - b300;
	//n1 = cross(b300b003, b300b030);
	n1 = cross(b300b030,b300b003);
	*/ 
	
	vec3 n2 = normalTC[1].xyz;
	/*
	vec3 b030b300 = b300 - b030;
	vec3 b030b003 = b003 - b030;
	//n2 = cross(b030b300, b030b003);
	n2 = cross(b030b003,b030b300);
	*/

	vec3 n3 = normalTC[2].xyz;
	/*
	vec3 b003b030 = b030 - b003;
	vec3 b003b300 = b300 - b003;
	//n3 = cross(b003b030, b003b300);
	n3 = cross(b003b300,b003b030);
	*/



	//n1 = normalize(n1);
	//n2 = normalize(n2);
	//n3 = normalize(n3);
	
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

	
	
	
	DataOut.normalTE = normalize( m_normal *
				vec3(n1 *w*w + n2 *u*u + n3 *v*v +
				n110 *w*u + n011 * u*v + n101 * w*v));
	
	

/*
	vec3 d1 = b300 - b030;
	vec3 d2 = b003 - b030;
	vec3 normal = normalize(cross(d1, d2));
	DataOut.normalTE = normal;
*/

    DataOut.l_dirTE = normalize(vec3(m_view * -l_dir));
    DataOut.tcTE = vec2(u, v);
    DataOut.colorTE = colorTC[0];
	if (noisevar1 == noisevar2 && noisevar2 == noisevar3){
		DataOut.colorTE = vec4(1., 0., 0.984, 0.8);
	} 
    DataOut.eTE = 0.0;
	gl_Position =  m_p * m_view * vec4(res,1.0);
}

