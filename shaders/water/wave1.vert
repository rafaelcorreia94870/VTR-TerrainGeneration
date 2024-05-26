#version 410
uniform mat4 m_vm, m_view, m_pvm, m_m;
uniform mat3 m_normal;
uniform vec4 l_dir;

in vec4 positionIn;
in vec3 normal;
in vec2 texCoord0;
in vec4 lightDir;

uniform float scale = 2;
uniform float timer;

uniform float height;
uniform float width;
uniform int nwaves;


out Data {
	vec3 normal;
	vec3 lightDir;
	vec4 eye;
} DataOut;

float pi = 3.14159265359;
float speed = 0.55;
float wavelength = 1000.0;
float teta = speed * 2.0 / wavelength;
float w = 2.0 * pi / wavelength;


vec2 grad( ivec2 z )  // replace this anything that returns a random vector
{
    // 2D to 1D  (feel free to replace by some other)
    int n = z.x+z.y*11111;

    // Hugo Elias hash (feel free to replace by another one)
    n = (n<<13)^n;
    n = (n*(n*n*15731+789221)+1376312589)>>16;

#if 0

    // simple random vectors
    return vec2(cos(float(n)),sin(float(n)));
    
#else

    // Perlin style vectors
    n &= 7;
    vec2 gr = vec2(n&1,n>>1)*2.0-1.0;
    return ( n>=6 ) ? vec2(0.0,gr.x) : 
           ( n>=4 ) ? vec2(gr.x,0.0) :
                              gr;
#endif                              
}

float noise( in vec2 p )
{
    ivec2 i = ivec2(floor( p ));
     vec2 f =       fract( p );
	
	vec2 u = f*f*(3.0-2.0*f); // feel free to replace by a quintic smoothstep instead

    return mix( mix( dot( grad( i+ivec2(0,0) ), f-vec2(0.0,0.0) ), 
                     dot( grad( i+ivec2(1,0) ), f-vec2(1.0,0.0) ), u.x),
                mix( dot( grad( i+ivec2(0,1) ), f-vec2(0.0,1.0) ), 
                     dot( grad( i+ivec2(1,1) ), f-vec2(1.0,1.0) ), u.x), u.y);
}

float ewave(float x, float z, float t, float ai, float wi, vec2 direction) {
    return ai * exp(sin(dot(direction, vec2(x,z)) *wi + t * teta));
}

vec2 ewavederive(float x, float z, float t, float ai, float wi, vec2 direction) {

    float common_term = dot(direction, vec2(x,z)) * wi + t * teta;
    float dy_dx = ai * exp(sin(common_term)) * cos(common_term) * wi * direction.x;
    float dy_dz = ai * exp(sin(common_term)) * cos(common_term) * wi * direction.y;
    return vec2(dy_dx, dy_dz);

}

vec3 sumOfWaves(float x, float z, float t, float initialSize, float initialWidth, int numWaves, vec2 tex) {
    float sum = 0.0;
    float dy_dx = 0.0;
    float dy_dz = 0.0;
    float size = initialSize;
    float ai = initialSize, wi=2.0*pi / initialWidth;
    for (int i = 0; i < numWaves; ++i) {
        float rng = noise(tex);
        rng = 1.0;
        //float waveHeight = simpleWave(x, t, size) + simpleWave(z, t, size);
        
        vec2 direction = normalize(vec2(rng, rng));
        //direction = vec2(1.0, 1.0);
        float waveHeight = ewave(x, z, t, ai, wi, direction);
        sum += waveHeight;

        vec2 dy_dx_dz = vec2(0.0, 0.0);

        //float dy_dx_temp = direction[0]*cos(dot(direction, vec2(x,z)));
        //float dy_dz_temp = direction[1]*cos(dot(direction, vec2(x,z)));
        dy_dx_dz = ewavederive(x, z, t, ai, wi, direction);
        
        dy_dx += dy_dx_dz[0];
        dy_dz += dy_dx_dz[1];

        size *= 0.7;
        ai*=0.82;
        wi*=1.18;
    }
    
    return vec3(sum,dy_dx, dy_dz);
}


void main() {
    
	vec4 position = m_m * positionIn;
	vec2 texture;
	vec3 waveData = sumOfWaves(position.x,position.z, timer, height, width ,nwaves, texture);

	float dy_dx = waveData.y;
    float dy_dz = waveData.z;
	position.y += waveHeight;

	vec3 tangent = vec3(1.0, 0.0, dy_dx);
    vec3 bitangent = vec3(0.0, 1.0, dy_dz);
	DataOut.normal = normalize(cross(tangent, bitangent));

	
	gl_Position = m_pv*position;
    DataOut.lightDir = lightDir;
    DataOut.eye = -m_vm * gl_Position;
}



