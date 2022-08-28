/* Toon Shader 
   Added vertex shader - adds height map from input noise texture
*/


shader_type spatial;

render_mode ambient_light_disabled;

uniform bool use_texture = true;
uniform vec4 albedo : hint_color = vec4(0.0f);
uniform sampler2D albedo_texture : hint_albedo;

uniform bool shade = true;
uniform vec4 shade_color : hint_color = vec4(0.0f, 0.0f, 0.0f, 1.0f);
uniform float shade_strength : hint_range(0.0f, 1.0f) = 0.5f;
uniform float shade_bias : hint_range(-1.0f, 1.0f) = 0.01f;

uniform bool specular = true;
uniform vec4 specular_color : hint_color = vec4(1.0f, 1.0f, 1.0f, 1.0f);
uniform float specular_strength : hint_range(0.0f, 1.0f) = 1.0f;
uniform float specular_bias : hint_range(0.0f, 1.0f) = 0.9f;

/* start vertex code */
 
uniform float height_scale : hint_range(0.0f, 10.0f) = 0.5;
uniform sampler2D displacement;
uniform float e : hint_range(0.0001f, 0.1f) = 0.01;

float get_height(vec2 pos) {
	vec2 tex_position = pos / 2.0 + 0.5;
	float height = texture(displacement, tex_position).x;
	return height * height_scale;
}

// sample 2 points to define plane, then calc normal of that plane
vec3 plane_norm2(vec3 pos) {
	// get two nearby samples
	vec3 A = vec3(pos.x+e, get_height(vec2(pos.x+e, pos.z+e)), pos.z+e);
	vec3 B = vec3(pos.x-e, get_height(vec2(pos.x-e, pos.z+e)), pos.z+e);

	// find normal of plane
	vec3 R = A - pos;
	vec3 S = B - pos;
	vec3 normal = cross(S, R);
	normal = normalize(normal);
	return normal;
}

void vertex() {
	float height = get_height(VERTEX.xz);
	VERTEX.y += height;

	// recalculate the normal
	NORMAL = plane_norm2(VERTEX);
}

/* end vertex code */

void fragment() {
	if (use_texture) {
		ALBEDO = albedo.rgb + texture(albedo_texture, UV).rgb;
	} else {
		ALBEDO = albedo.rgb;
	}
}

void light() {
	DIFFUSE_LIGHT = ALBEDO.rgb;
	//SPECULAR_LIGHT = vec3(0.0f);

	/* Diffuse */
	if (shade){
		// init diffuse variables
		float inv_shade_strength = 1.0 - shade_strength;
		float NdotL = dot(NORMAL, LIGHT);
		float light_intensity = step(shade_bias, NdotL);
		light_intensity = NdotL > shade_bias ? 1.0 : inv_shade_strength;

		// mix ablebo with shade color weighted by light intensity
		vec3 out_diffuse_color = mix(shade_color.rgb, ALBEDO.rgb, vec3(light_intensity));

		// output diffuse
		DIFFUSE_LIGHT = out_diffuse_color;

	}

	/* Specular */
	if (specular) {
		// init Specular variables
		vec3 n = normalize(NORMAL); // normalize normal vector
		float s = dot(-LIGHT, n); // calc vector scale factor for n
		vec3 N = s * n; // direction of normal and length of projected point of light source

		// calculate projection vector
		vec3 P = LIGHT + N; // light vector projected onto normal vector

		// calcuate reflection vector
		vec3 R = N + P; // reflection vector is angle between normal and projected vector

		// calculate vector from fragment to camera
		vec3 to_camera = -1.0 * VIEW;
		//vec3 to_camera = VIEW;

		// calculate the cosine of the angle between the reflection vector and view vector
		R = normalize(R);
		to_camera = normalize(to_camera);
		float cos_angle = dot(R, to_camera);
		cos_angle = clamp(cos_angle, 0.0, 1.0);

		// determine specular intensity
		float specular_intensity = cos_angle < specular_bias ? 1.0 : 0.0;

		// mix diffuse_out with highlight color weighted by specular intensity
		vec3 highlight_color = specular_color.rgb;
		vec3 mixed_highlight_color = mix(specular_color.rgb * specular_strength, DIFFUSE_LIGHT,  vec3(specular_intensity));
		vec3 object_color = DIFFUSE_LIGHT;
		vec3 out_specular_color = specular_intensity < 1.0 ? mixed_highlight_color : object_color;

		// output specular
		SPECULAR_LIGHT = out_specular_color;

	}
}