
#define PROCESSING_COLOR_SHADER


uniform vec2 resolution;
uniform float freq;


void main()
{
	float g = 0.5*(1.0+cos(freq*gl_FragCoord.x/resolution.x*6.28));
	gl_FragColor = vec4(g,g,g,1);

//	gl_FragColor = vec4(1.0,0.0,0.0,1);
}