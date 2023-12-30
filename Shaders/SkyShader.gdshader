shader_type sky;

uniform vec3 skyColor : source_color;
uniform vec3 horizonColor : source_color;
uniform sampler2D skyTexture; 
uniform sampler2D skyTexture2;
uniform float tex1_y_offset;
uniform float tex2_y_offset;
uniform float tex1_time_offset;
uniform float tex2_time_offset; 

void sky() {
	
	vec2 skyCoords = SKY_COORDS;
	skyCoords.x += TIME / tex1_time_offset;
	skyCoords.y += tex1_y_offset;
    vec4 tex_a = texture( skyTexture, skyCoords );
    // read texture B
	skyCoords.x = SKY_COORDS.x - TIME / tex2_time_offset;
	skyCoords.y += tex2_y_offset;
    vec4 tex_b = texture( skyTexture2, skyCoords );
    // multiply them together
    vec4 mult_result = tex_a + tex_b;
    // set as the canvasitem output color
	
	float col = clamp(EYEDIR.y / 0.5, 0.0, 1.0);
	vec3 finalColor = mix(horizonColor, skyColor, col);
	finalColor = mult_result.rgb + finalColor;
    COLOR.rgb = finalColor;
	
//	float col = clamp(EYEDIR.y / 0.5, 0.0, 1.0);
//	vec3 finalColor = mix(horizonColor, skyColor, col);
//	vec2 skyCoords = SKY_COORDS;
//	skyCoords.x += TIME / 200.0;
//	vec3 c = texture(skyTexture2, skyCoords).rgb;
//	COLOR = mix(finalColor, c, finalColor);
}
