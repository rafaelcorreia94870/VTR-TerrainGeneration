#version 440

layout(points) in;
layout(triangle_strip, max_vertices = 1023) out;


uniform mat4 m_pvm;
uniform mat4 m_m;
uniform mat4 m_view;

uniform float FOV, NEAR, FAR;
uniform vec4 POS;
uniform vec4 LOOKAT;



uniform int squareSize;
uniform int chunkSize;

void main() {
	vec4 dir = LOOKAT - POS;
	vec3 forward = normalize(dir.xyz);
	vec3 start = vec3(0,0,1);

	float angle = atan(forward.z, forward.x);

	mat3 rotationMatrix = mat3(
        cos(angle), 0, sin(angle),
        0, 1, 0,
        -sin(angle), 0, cos(angle)
    );

    
	
    for (int i = 0; i < chunkSize*squareSize; i+=squareSize) {
		for(int j = 0; j < chunkSize*squareSize; j+=squareSize) {
			vec4 position = gl_in[0].gl_Position + vec4(i, 0.0, j, 0.0);
            position = vec4(rotationMatrix * position.xyz, 1.0);
			position.xyz = position.xyz + POS.xyz;
			position.w = 1.0;
			position.y = 0.0;
			gl_Position = m_pvm * position;
			//gl_Position = m_pvm * position;
            EmitVertex();

            position = gl_in[0].gl_Position + vec4(i + squareSize, 0.0, j, 0.0);
            position = vec4(rotationMatrix * position.xyz, 1.0);
			position.xyz = position.xyz + POS.xyz;
			position.w = 1.0;
			position.y = 0.0;
			gl_Position = m_pvm * position;
			
			//gl_Position = m_pvm * position;
            EmitVertex();

            position = gl_in[0].gl_Position + vec4(i, 0.0, j + squareSize, 0.0);
            position = vec4(rotationMatrix * position.xyz, 1.0);
			position.xyz = position.xyz + POS.xyz;
			position.w = 1.0;
			position.y = 0.0;
			gl_Position = m_pvm * position;
			//gl_Position = m_pvm * position;
            EmitVertex();

            position = gl_in[0].gl_Position + vec4(i + squareSize, 0.0, j + squareSize, 0.0);
            position = vec4(rotationMatrix * position.xyz, 1.0);
			position.xyz = position.xyz + POS.xyz;
			position.w = 1.0;
			position.y = 0.0;
			gl_Position = m_pvm * position;
			//gl_Position = m_pvm * position;
            EmitVertex();

            EndPrimitive();
            
		}
    }
            
    
}