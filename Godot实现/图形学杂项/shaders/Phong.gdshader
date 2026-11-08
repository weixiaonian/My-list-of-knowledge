shader_type spatial;
// 不要用 render_mode specular_disabled，

// 高光指数（Phong 的 n），必须 >= 1；0 会让 pow(x,0) 恒等于 1
uniform float n : hint_range(1.0, 256.0, 1.0) = 32.0;


uniform sampler2D base_tex : source_color, hint_default_white;


void fragment()
{
	ROUGHNESS = 1.0;
	SPECULAR = 0.0;
	ALBEDO = texture(base_tex, UV).rgb;
}

void light()
{
	// 基础兰伯特打底
	float ndotl = max(dot(NORMAL, LIGHT), 0.0);
	DIFFUSE_LIGHT += LIGHT_COLOR / PI * ATTENUATION * ndotl;

	// Phong 高光：R 是 LIGHT 关于 NORMAL 的镜面反射方向
	
	vec3 R = reflect(-LIGHT, NORMAL);
	float specular = pow(max(dot(R, VIEW), 0.0), n);
	SPECULAR_LIGHT += specular * ATTENUATION * ndotl * LIGHT_COLOR / PI;
	
}
