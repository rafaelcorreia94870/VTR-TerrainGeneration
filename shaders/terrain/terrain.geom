#version 440

in Data {
    vec3 normalTE;
	vec3 l_dirTE;
    vec4 colorTE;
    vec2 tcTE;
    float eTE;
	float isInsideFrustumTE;
} DataIn[];

out Data {
	vec3 normalGS;
	vec3 l_dirGS;
	vec4 colorGS;
	vec2 tcGS;
	float eGS;
	float isInsideFrustumGS;
} DataOut;

void main()
{
    DataOut.normalGS = DataIn[0].normalTE;
    DataOut.l_dirGS = DataIn[0].l_dirTE;
    DataOut.colorGS = DataIn[0].colorTE;
    DataOut.tcGS = DataIn[0].tcTE;
    DataOut.eGS = DataIn[0].eTE;
    DataOut.isInsideFrustumGS = DataIn[0].isInsideFrustumTE;
}

