/* 
This shader is under MIT license. Feel free to use, improve and 
change this shader according to your needs and consider sharing 
the modified result to godotshaders.com.
*/

shader_type canvas_item;

uniform sampler2D u_dither_tex;

float get_color_distance(vec4 color1, vec4 color2){
	return sqrt(pow(color1.r - color2.r, 2) + pow(color1.g - color2.g, 2) + pow(color1.b - color2.b, 2));
}


void fragment() 
{
	
	vec4 currColor = texture(TEXTURE, UV);
	float distanceArr[16];
	float minDistance = 255.0;
	for(int i = 0; i < 16; i++){
		float paletteCoords = 1.0 / 16.0 * float(i);
		minDistance = min(minDistance,distance(currColor, texture(u_dither_tex,vec2(paletteCoords,1.0))));
	}
	for(int i = 0; i < 16; i++){
		float paletteCoords = 1.0 / 16.0 * float(i);
		if(minDistance == distance(currColor, texture(u_dither_tex,vec2(paletteCoords,1.0)))){
			COLOR = texture(u_dither_tex,vec2(paletteCoords,1.0));
		}
	}
	
	//COLOR = texture(u_dither_tex,vec2(.14,1.0));//texture(TEXTURE, UV); //read from texture
	//COLOR.b = 1.0; //set blue channel to 1.0
}