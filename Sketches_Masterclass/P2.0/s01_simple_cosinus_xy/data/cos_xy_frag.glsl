#define PROCESSING_COLOR_SHADER



uniform vec2 resolution;
uniform float freqx;
uniform float freqy;

void main()
{
	float m = 0.5*(sin(freqy*gl_FragCoord.y/resolution.y*6.28)+1.0);
	float g = m*0.5*(1.0+cos(freqx*gl_FragCoord.x/resolution.x*6.28));
	gl_FragColor = vec4(g,g,g,1);
}