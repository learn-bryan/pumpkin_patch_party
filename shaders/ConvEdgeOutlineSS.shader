/* Screen Space Outline Shader

   This shader must be applied to a 2x2 Quad Mesh. Recommended to set the extra
   cull margin on the Quad Mesh to the max value.

   Pixels that are detected as edges will be colored the outline_color.
*/

shader_type spatial;
render_mode unshaded;

uniform float outline_intensity : hint_range(0, 5) = 1;
uniform float outline_bias : hint_range(-10, 10) = 0;
uniform vec4 outline_color : hint_color = vec4(0.0, 0.0, 0.0, 1.0);

/* Position the target mesh in front of the camera */
void vertex() {
	POSITION = vec4(VERTEX, 1.0);
}

/* Outline - Convolution Edge Detection
   Use convolutions on camera depth texture to detect edges.
   Currently using simple Robert's Cross kernel but could be updated to use
   techniques with multiple convolutions like: Sobel, Prewitt, Kirsh.
*/
void fragment() {
	ALBEDO = outline_color.rgb;
	
	// Roberts cross kernels
	mat2 kernelX = mat2(vec2(1.0, 0.0), vec2(0.0, -1.0));
	mat2 kernelY = mat2(vec2(0.0, -1.0), vec2(1.0, 0.0));

	vec2 screen_size = vec2(textureSize(SCREEN_TEXTURE, 1));

	float px = 0.5/screen_size.x;
	float py = 0.5/screen_size.y;

	// sample pixel neighborhood depths
	float top_left = texture(DEPTH_TEXTURE, SCREEN_UV+vec2(-px, -py)).x;
	float top_right = texture(DEPTH_TEXTURE, SCREEN_UV+vec2(px, -py)).x;
	float bottom_left = texture(DEPTH_TEXTURE, SCREEN_UV+vec2(-px, py)).x;
	float bottom_right = texture(DEPTH_TEXTURE, SCREEN_UV+vec2(px, py)).x;
	
	// calculate the sum of the squares of the differences between diagonal pixels
	// TODO: optimize with dot products
	float horizontal = top_left * kernelX[0][0];
	horizontal += bottom_right * kernelX[1][1];
	float vertical = bottom_left * kernelY[0][1];
	vertical += top_right * kernelY[1][0];
	
	// define the edge
	float edge = sqrt((horizontal * horizontal) + (vertical * vertical));
	
	// color the edge
	ALPHA = edge;
	ALPHA *= 1000.0*outline_intensity;
	ALPHA += outline_bias;
	ALPHA *= outline_color.a;
	ALPHA = clamp(ALPHA, 0.0, 1.0);
}