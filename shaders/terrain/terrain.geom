#version 440

layout (triangles) in;
layout (triangle_strip, max_vertices = 6) out;

uniform mat4 m_pvm;
uniform mat4 m_view;
uniform mat4 m_m;

const int gridSize = 200;
const float gridSpacing = 10.0;

void main()
{
    for (int i = 0; i < gl_in.length(); i++)
    {
        gl_Position = m_pvm * m_view * m_m * gl_in[i].gl_Position;
        EmitVertex();
    }

    // Calculate the camera distance
    float cameraDistance = length(gl_Position.xyz);

    // Generate new grids based on camera distance
    if (cameraDistance > gridSize * gridSpacing)
    {
        for (int x = -gridSize; x <= gridSize; x++)
        {
            for (int z = -gridSize; z <= gridSize; z++)
            {
                // Calculate the grid position
                vec3 gridPosition = vec3(x * gridSpacing, 0.0, z * gridSpacing);

                // Modify the vertices to include the new heights
                for (int i = 0; i < gl_in.length(); i++)
                {
                    gl_Position = m_pvm * m_view * m_m * (gl_in[i].gl_Position + vec4(gridPosition, 0.0));
                    EmitVertex();
                }

                EndPrimitive();
            }
        }
    }
}