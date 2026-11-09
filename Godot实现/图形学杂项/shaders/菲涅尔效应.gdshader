shader_type spatial;

uniform float p :hint_range(1.0, 256.0, 0.1) = 5.0;

void light()
{
	float rim = pow(max(1.0 - max(dot(NORMAL,VIEW),0.0),0.0),p);
	DIFFUSE_LIGHT += rim * dot(NORMAL,LIGHT) * LIGHT_COLOR / PI * ATTENUATION;
}