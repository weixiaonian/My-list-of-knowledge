shader_type spatial;

uniform sampler2D base_tex : source_color, hint_default_white;
uniform float n : hint_range(1.0, 256.0, 1.0) = 32.0;
uniform float e0:hint_range(0.0, 1.0, 0.1) = 0.3;
uniform float e1:hint_range(0.0, 1.0, 0.1) = 0.9;



void fragment()
{
	ROUGHNESS = 1.0;
	SPECULAR = 0.0;
	ALBEDO = texture(base_tex, UV).rgb;
}

void light()
{
	float ndotl = dot(NORMAL, LIGHT);
	float lambert = max(ndotl, 0.0);
	DIFFUSE_LIGHT += LIGHT_COLOR / PI * lambert * ATTENUATION;

	
	vec3 half_vec = LIGHT + VIEW;
	float half_len = length(half_vec);
	vec3 H = half_len > 1e-5 ? half_vec / half_len : NORMAL;


	float specular = pow(max(dot(NORMAL, H), 0.0), n);
	float n_specular = smoothstep(e0,e1,specular);
	SPECULAR_LIGHT += n_specular * lambert * ATTENUATION * LIGHT_COLOR / PI;
}
