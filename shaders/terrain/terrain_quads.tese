layout(quads, equal_spacing, ccw) in;

uniform	mat4 m_pvm, m_view, m_p, m_m;
uniform	mat3 m_normal;
uniform vec4 l_dir;
uniform float timer;
uniform float scale;
uniform vec4 LOOKAT, POS;
uniform int squareSize;
uniform int chunkSize;

uniform int num_octaves;
uniform float persistence;
uniform float lacunarity;
uniform float heightmult;
float minValue = 2;
float maxValue = 400;


patch in vec4 colorTC;
patch in vec3 init_tc;
patch in float lDetail;

out Data {
    vec3 normalTE;
	vec3 l_dirTE;
    vec4 colorTE;
    vec2 tcTE;
    float eTE;
} DataOut;


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

    vec3 p = gl_in[0].gl_Position.xyz;

    vec4 pontos[16];
    for (int i = 0; i < 16; ++i) {
        pontos[i] = gl_in[i].gl_Position;
        pontos[i].y = fbm(vec2(pontos[i].x, pontos[i].z));
        pontos[i] = vec4((rotationMatrix * pontos[i].xyz) + POS.xyz, 1.0);
    }

    float u = gl_TessCoord.x;
    float v = gl_TessCoord.y;

    //PARA VER SE FUNCIONA
/*
    vec4 p00 = gl_in[ 0].gl_Position;
    vec4 p10 = gl_in[ 1].gl_Position;
    vec4 p20 = gl_in[ 2].gl_Position;
    vec4 p30 = gl_in[ 3].gl_Position;
    vec4 p01 = gl_in[ 4].gl_Position;
    vec4 p11 = gl_in[ 5].gl_Position;
    vec4 p21 = gl_in[ 6].gl_Position;
    vec4 p31 = gl_in[ 7].gl_Position;
    vec4 p02 = gl_in[ 8].gl_Position;
    vec4 p12 = gl_in[ 9].gl_Position;
    vec4 p22 = gl_in[10].gl_Position;
    vec4 p32 = gl_in[11].gl_Position;
    vec4 p03 = gl_in[12].gl_Position;
    vec4 p13 = gl_in[13].gl_Position;
    vec4 p23 = gl_in[14].gl_Position;
    vec4 p33 = gl_in[15].gl_Position;
    ////
    */

    float bu0 = (1.-u) * (1.-u) * (1.-u);
    float bu1 = 3. * u * (1.-u) * (1.-u);
    float bu2 = 3. * u * u * (1.-u);
    float bu3 = u * u * u;

    float dbu0 = -3. * (1.-u) * (1.-u);
    float dbu1 = 3. * (1.-u) * (1.-3.*u);
    float dbu2 = 3. * u * (2.-3.*u);
    float dbu3 = 3. * u * u;

    float bv0 = (1.-v) * (1.-v) * (1.-v);
    float bv1 = 3. * v * (1.-v) * (1.-v);
    float bv2 = 3. * v * v * (1.-v);
    float bv3 = v * v * v;

    float dbv0 = -3. * (1.-v) * (1.-v);
    float dbv1 = 3. * (1.-v) * (1.-3.*v);
    float dbv2 = 3. * v * (2.-3.*v);
    float dbv3 = 3. * v * v;
    gl_Position = m_p * m_view * (bu0 * (bv0 * pontos[0] + bv1 * pontos[4] + bv2 * pontos[8] + bv3 * pontos[12]) +
                  bu1 * (bv0 * pontos[1] + bv1 * pontos[5] + bv2 * pontos[9] + bv3 * pontos[13]) +
                  bu2 * (bv0 * pontos[2] + bv1 * pontos[6] + bv2 * pontos[10] + bv3 * pontos[14]) +
                  bu3 * (bv0 * pontos[3] + bv1 * pontos[7] + bv2 * pontos[11] + bv3 * pontos[15]));


    vec4 dpdu = dbu0 * (bv0 * pontos[0] + bv1 * pontos[4] + bv2 * pontos[8] + bv3 * pontos[12]) +
                dbu1 * (bv0 * pontos[1] + bv1 * pontos[5] + bv2 * pontos[9] + bv3 * pontos[13]) +
                dbu2 * (bv0 * pontos[2] + bv1 * pontos[6] + bv2 * pontos[10] + bv3 * pontos[14]) +
                dbu3 * (bv0 * pontos[3] + bv1 * pontos[7] + bv2 * pontos[11] + bv3 * pontos[15]);

    vec4 dpdv = bu0 * (dbv0 * pontos[0] + dbv1 * pontos[4] + dbv2 * pontos[8] + dbv3 * pontos[12]) +
                bu1 * (dbv0 * pontos[1] + dbv1 * pontos[5] + dbv2 * pontos[9] + dbv3 * pontos[13]) +
                bu2 * (dbv0 * pontos[2] + dbv1 * pontos[6] + dbv2 * pontos[10] + dbv3 * pontos[14]) +
                bu3 * (dbv0 * pontos[3] + dbv1 * pontos[7] + dbv2 * pontos[11] + dbv3 * pontos[15]);


/*
    gl_Position = bu0 * ( bv0*p00 + bv1*p01 + bv2*p02 + bv3*p03 )
                + bu1 * ( bv0*p10 + bv1*p11 + bv2*p12 + bv3*p13 )
                + bu2 * ( bv0*p20 + bv1*p21 + bv2*p22 + bv3*p23 )
                + bu3 * ( bv0*p30 + bv1*p31 + bv2*p32 + bv3*p33 );

    vec4 dpdu = dbu0 * ( bv0*p00 + bv1*p01 + bv2*p02 + bv3*p03 )
                + dbu1 * ( bv0*p10 + bv1*p11 + bv2*p12 + bv3*p13 )
                + dbu2 * ( bv0*p20 + bv1*p21 + bv2*p22 + bv3*p23 )
                + dbu3 * ( bv0*p30 + bv1*p31 + bv2*p32 + bv3*p33 );
    vec4 dpdv = bu0 * ( dbv0*p00 + dbv1*p01 + dbv2*p02 + dbv3*p03 )+ bu1 * ( dbv0*p10 + dbv1*p11 + dbv2*p12 + dbv3*p13 )+ bu2 * ( dbv0*p20 + dbv1*p21 + dbv2*p22 + dbv3*p23 )+ bu3 * ( dbv0*p30 + dbv1*p31 + dbv2*p32 + dbv3*p33 );
*/


    DataOut.normalTE = normalize(cross(dpdu.xyz, dpdv.xyz));
    DataOut.colorTE = colorTC;
    DataOut.eTE = 0.0;

/*



    float u = gl_TessCoord.x;
    float v = gl_TessCoord.y;

    float vertexX = init_tc.x + chunkSize * squareSize *  (2*v -1) ;
    float vertexZ = init_tc.z + chunkSize * squareSize *  (2*u -1) ;
    vec4 vertex = vec4(p.x, 0.0, p.z, 1.0);

	DataOut.l_dirTE = normalize(vec3(m_view * -l_dir));
    DataOut.tcTE = vec2(u, v);
    DataOut.colorTE = colorTC;
    
    float f = (chunkSize * 2) / lDetail;

    float p1X = vertex.x +squareSize;
    float p1Z = vertex.z ;
    vec3 p1 = vec3(p1X, 0., p1Z);
    p1 = rotationMatrix * p1;
    p1 += POS.xyz;
    p1.y = fbm(vec2(p1.x, p1.z));

    float p2X = vertex.x;
    float p2Z = vertex.z + squareSize;
    vec3 p2 = vec3(p2X, 0., p2Z);
    p2 = rotationMatrix * p2;
    p2 += POS.xyz;
    p2.y = fbm(vec2(p2.x, p2.z));

    float p3X = vertex.x + squareSize;
    float p3Z = vertex.z + squareSize;
    vec3 p3 = vec3(p3X, 0., p3Z);
    p3 = rotationMatrix * p3;
    p3 += POS.xyz;
    p3.y = fbm(vec2(p3.x, p3.z));


    float p4X = vertex.x;
    float p4Z = vertex.z;
    vec3 p4 = vec3(p4X, 0, p4Z);
    p4 = rotationMatrix * p4;
    p4 += POS.xyz;
    p4.y = fbm(vec2(p4.x, p4.z));

    vec3 v1 = p2 - p1;
    vec3 v2 = p4 - p3;
    
    DataOut.normalTE = normalize(m_normal * normalize(cross(v1, v2)));
    DataOut.colorTE = colorTC;
    gl_Position = m_pvm * vec4(p4,1.0);

    DataOut.eTE = 0.0;
	//gl_Position =  m_p * m_view * vec4(res,1.0);
    */
}