shader_type spatial;

render_mode unshaded, cull_front;

uniform vec4 outline_color : source_color = vec4(0.03, 0.03, 0.03, 1.0);


uniform float outline_width : hint_range(0.0, 0.5, 0.001) = 0.03;

void vertex() {
	// 模型自身的缩放：用来把“世界空间宽度”换算回模型空间，
	// 否则同一个材质在缩放过的节点上描边会变粗/变细。
	vec3 model_scale = vec3(
		length(MODEL_MATRIX[0].xyz),
		length(MODEL_MATRIX[1].xyz),
		length(MODEL_MATRIX[2].xyz));
	model_scale = max(model_scale, vec3(1e-4)); // 防止缩放为 0 时除零

	// 注意：Godot 4 里 VERTEX / NORMAL 进入 vertex() 时已经做过蒙皮变换，
	// 所以这段对骨骼动画模型同样有效。
	VERTEX += normalize(NORMAL) * (outline_width / model_scale);
}

void fragment() {
	ALBEDO = outline_color.rgb;
}
