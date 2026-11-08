shader_type spatial;

uniform sampler2D base_tex : source_color, hint_default_white;
uniform float n : hint_range(1.0, 256.0, 1.0) = 32.0;

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

	// 半程向量：只归一化，不要把分量 clamp 到 0（那会把方向掰歪且不再是单位向量）
	vec3 half_vec = LIGHT + VIEW;
	float half_len = length(half_vec);
	vec3 H = half_len > 1e-5 ? half_vec / half_len : NORMAL;

	// pow 的底数必须非负，否则结果未定义（负数底数会得到 NaN）
	float specular = pow(max(dot(NORMAL, H), 0.0), n);
	SPECULAR_LIGHT += specular * lambert * ATTENUATION * LIGHT_COLOR / PI;
}
