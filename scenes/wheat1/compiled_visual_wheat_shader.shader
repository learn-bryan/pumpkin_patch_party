shader_type spatial;
render_mode cull_disabled, diffuse_toon, specular_toon, unshaded;

uniform sampler2D tex_frg_6 : hint_normal;



void vertex() {
// Input:8
	float n_out8p0 = TIME;

// Input:9
	mat4 n_out9p0 = WORLD_MATRIX;

// TransformDecompose:10
	vec3 n_out10p0 = n_out9p0[0].xyz;
	vec3 n_out10p1 = n_out9p0[1].xyz;
	vec3 n_out10p2 = n_out9p0[2].xyz;
	vec3 n_out10p3 = n_out9p0[3].xyz;

// ScalarOp:11
	float n_out11p0 = n_out8p0 * dot(n_out10p0, vec3(0.333333, 0.333333, 0.333333));

// ScalarFunc:7
	float n_out7p0 = sin(n_out11p0);

// ScalarOp:12
	float n_in12p1 = 0.20000;
	float n_out12p0 = n_out7p0 * n_in12p1;

// Input:2
	vec3 n_out2p0 = VERTEX;

// VectorDecompose:4
	float n_out4p0 = n_out2p0.x;
	float n_out4p1 = n_out2p0.y;
	float n_out4p2 = n_out2p0.z;

// ScalarOp:14
	float n_in14p0 = 1.00000;
	float n_out14p0 = n_in14p0 + n_out4p1;

// ScalarOp:13
	float n_out13p0 = n_out12p0 * n_out14p0;

// ScalarOp:5
	float n_out5p0 = n_out13p0 + n_out4p0;

// ScalarOp:15
	float n_in15p1 = 1.00000;
	float n_out15p0 = n_out4p1 + n_in15p1;

// VectorCompose:6
	vec3 n_out6p0 = vec3(n_out5p0, n_out15p0, n_out4p2);

// Output:0
	VERTEX = n_out6p0;

}

void fragment() {
// Color:3
	vec3 n_out3p0 = vec3(0.826070, 0.832031, 0.068959);
	float n_out3p1 = 1.000000;

// Color:4
	vec3 n_out4p0 = vec3(0.765625, 0.688598, 0.061375);
	float n_out4p1 = 1.000000;

// Input:9
	vec3 n_out9p0 = vec3(UV, 0.0);

// VectorDecompose:8
	float n_out8p0 = n_out9p0.x;
	float n_out8p1 = n_out9p0.y;
	float n_out8p2 = n_out9p0.z;

// VectorCompose:7
	vec3 n_out7p0 = vec3(n_out8p1, n_out8p0, n_out8p2);

// Texture:6
	vec4 tex_frg_6_read = texture(tex_frg_6, n_out7p0.xy);
	vec3 n_out6p0 = tex_frg_6_read.rgb;
	float n_out6p1 = tex_frg_6_read.a;

// ScalarOp:10
	float n_in10p1 = 1.00000;
	float n_out10p0 = dot(n_out6p0, vec3(0.333333, 0.333333, 0.333333)) * n_in10p1;

// VectorMix:5
	vec3 n_out5p0 = mix(n_out3p0, n_out4p0, vec3(n_out10p0));

// Output:0
	ALBEDO = n_out5p0;

}

void light() {
// Output:0

}
