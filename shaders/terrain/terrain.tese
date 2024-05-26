
layout(triangles, fractional_odd_spacing, ccw) in;

uniform	mat4 m_pvm, m_view;
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


in vec4 normalTC[];
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
	vec4 b300 = posTC[0];
	vec4 b030 = posTC[1];
	vec4 b003 = posTC[2];

	float noisevar1 = 0.0;
	float noisevar2 = 0.0;
	float noisevar3 = 0.0;
	float amplitude = 1.0;
	float frequency = 1.0;
	for(int i = 1; i < num_octaves; ++i) {
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
	b300.y = heightmult * noisevar1;
	b030.y = heightmult * noisevar2;
	b003.y = heightmult * noisevar3;
	
	vec4 n1 = normalTC[0];
	vec4 n2 = normalTC[1];
	vec4 n3 = normalTC[2];
	
	float w12 = dot (b030 - b300, n1);
	float w21 = dot (b300 - b030, n2);
	
	float w13 = dot (b003 - b300, n1);
	float w31 = dot (b300 - b003, n3);
	
	float w23 = dot (b003 - b030, n2);
	float w32 = dot (b030 - b003, n3);
	
	vec4 b210 = (2*b300 + b030 - w12*n1) / 3 ;
	vec4 b120 = (2*b030 + b300 - w21*n2) / 3 ;

	vec4 b021 = (2*b030 + b003 - w23*n2) / 3 ;
	vec4 b012 = (2*b003 + b030 - w32*n3) / 3 ;

	vec4 b102 = (2*b003 + b300 - w31*n3) / 3 ;
	vec4 b201 = (2*b300 + b003 - w13*n1) / 3 ;

	vec4 E = (b210 + b120 + b021 + b012 + b201 + b102) / 6;
	vec4 V = (b300 + b030 + b003) / 3;

	vec4 b111 = E + (E - V) / 2;
	
	float u = gl_TessCoord.x;
	float v = gl_TessCoord.y;                                           
	float w = gl_TessCoord.z;



	vec4 res = b300 * w*w*w + b030 * u*u*u + b003 * v*v*v +
				b210 * 3 * w*w*u + b120 * 3*w*u*u + b201 * 3 * w*w*v +
				b021 * 3*u*u*v + b102 * 3*w*v*v + b012 * 3*u*v*v +
				b111*6*w*u*v;
	//n sei
	//res.y += 2 * snoise(res.xy);

	float v12 = 2 * (dot (b030 - b300, n1+n2)/dot (b030 - b300, b030 - b300));
	float v23 = 2 * (dot (b003 - b030, n2+n3)/dot (b003 - b030, b003 - b030));
	float v31 = 2 * (dot (b300 - b003, n3+n1)/dot (b003 - b300, b003 - b300));
	
	vec4 n110 = normalize ( n1 + n2 - v12 *(b030 - b300));
	vec4 n011 = normalize ( n2 + n3 - v23 *(b003 - b030));
	vec4 n101 = normalize ( n3 + n1 - v31 *(b300 - b003));

	// Recalculate the perturbed normals
    vec4 perturbedNormal = vec4(0.0);
    perturbedNormal += n1 * w*w;
    perturbedNormal += n2 * u*u;
    perturbedNormal += n3 * v*v;
    perturbedNormal += n110 * w*u;
    perturbedNormal += n011 * u*v;
    perturbedNormal += n101 * w*v;
    perturbedNormal = normalize(perturbedNormal);

	
	DataOut.normalTE = normalize(m_normal * 
				vec3(n1 *w*w + n2 *u*u + n3 *v*v +
				n110 *w*u + n011 * u*v + n101 * w*v));

    DataOut.l_dirTE = normalize(vec3(m_view * -l_dir));
    DataOut.tcTE = vec2(u, v);
    DataOut.colorTE = colorTC[0];
    DataOut.eTE = 0.0;
			
	gl_Position = m_pvm * res;
}

