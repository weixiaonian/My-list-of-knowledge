shader_type spatial;


// hint_default_white：未挂贴图时采样结果为白色，避免出现纯黑
uniform sampler2D base_text : source_color, hint_default_white;

void fragment()
{
	ROUGHNESS = 1.0;
	SPECULAR = 0.0;
	ALBEDO = texture(base_text,UV).rgb;
}

void light()
{
	// 半兰伯特：把 [-1,1] 的 N·L 重映射到 [0,1]，阴影不会全黑
	float ndotl = dot(NORMAL, LIGHT) * 0.5 + 0.5;
	// Valve 的经典写法会再平方一次，用来压暗明暗交界处
	float ndotl_p2 = ndotl * ndotl;
	// LIGHT_COLOR 已包含 PI，所以这里除 PI 才与引擎默认亮度一致
	DIFFUSE_LIGHT += LIGHT_COLOR / PI * ATTENUATION * ndotl_p2;
}