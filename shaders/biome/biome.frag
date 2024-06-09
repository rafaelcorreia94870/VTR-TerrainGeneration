#version 460

uniform int t_octaves;
uniform float t_limit1;
uniform float t_limit2;
uniform float t_freq;
uniform int p_octaves;
uniform float p_limit1;
uniform float p_limit2;
uniform float p_freq;
uniform float p_offset_x;
uniform float p_offset_y;

in vec2 tc;

out vec4 biome_map;


float noise(vec2 pos);


void main() {

    vec2 t = tc;
    float c = 0.0;
    int temp;
    float freq = t_freq;
    for (int i = 0; i < t_octaves; ++i) {
        c +=  noise(t) * freq;
        freq *= 0.5;
        t *= 2;
    }

    if(c < t_limit1) { // cold
        temp = 0;
    }
    else if(c < t_limit2) { // temperate
        temp = 1;
    }
    else{ // hot
        temp = 2;
    }

    t = tc + vec2(p_offset_x, p_offset_y);
    c = 0.0;
    freq = p_freq;
    for (int i = 0; i < p_octaves; ++i) {
        c +=  noise(t) * freq;
        freq *= 0.5;
        t *= 2;
    }

    vec3 clr = vec3(0.0);
    if(c < p_limit1) { // dry
        switch(temp){
            case 0:
                clr = vec3(0.7, 0.7, 1.0); // tundra
                break;
            case 1:
                clr = vec3(0.6, 0.8, 0.1); // grassland
                break;
            case 2:
                clr = vec3(1.0, 1.0, 0.0); // desert
                break;
        }
    }
    else if(c < p_limit2) { // moderate
        switch(temp){
            case 0:
                clr = vec3(0.0, 0.0, 0.6); // ocean
                break;
            case 1:
                clr = vec3(0.1, 0.6, 0.1); // forest
                break;
            case 2:
                clr = vec3(1.0, 0.7, 0.0); // savanna
                break;
        }
    }
    else{ // wet
        switch(temp){
            case 2:
                clr = vec3(0.3, 0.4, 0.1); // jungle
                break;
            default:
                clr = vec3(0.0, 0.0, 0.6); // ocean
                break;
        }
    }

    //c = c * 0.5 + 0.5;

    biome_map = vec4(clr, 1); 
}

/* // Original code
void main() {

    vec2 t = tc;
    float c = 0.0;;
    float freq = 1.0;
    for (int i = 0; i < bm_octaves; ++i) {
        c +=  noise(t) * freq;
        freq *= 0.5;
        t *= 2;
    }

    c = c * 0.5 + 0.5;

    color = vec4(c); 
}

*/

// The MIT License
// Copyright © 2013 Inigo Quilez
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
// https://www.youtube.com/c/InigoQuilez
// https://iquilezles.org


// Gradient Noise (http://en.wikipedia.org/wiki/Gradient_noise), not to be confused with
// Value Noise, and neither with Perlin's Noise (which is one form of Gradient Noise)
// is probably the most convenient way to generate noise (a random smooth signal with 
// mostly all its energy in the low frequencies) suitable for procedural texturing/shading,
// modeling and animation.
//
// It produces smoother and higher quality than Value Noise, but it's of course slighty more
// expensive.
//
// The princpiple is to create a virtual grid/latice all over the plane, and assign one
// random vector to every vertex in the grid. When querying/requesting a noise value at
// an arbitrary point in the plane, the grid cell in which the query is performed is
// determined, the four vertices of the grid are determined and their random vectors
// fetched. Then, the position of the current point under  evaluation relative to each
// vertex is doted (projected) with that vertex' random vector, and the result is
// bilinearly interpolated with a smooth interpolant.

// All noise functions here:
//
// https://www.shadertoy.com/playlist/fXlXzf&from=0&num=12


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