uniform vec2 resolution;

void main()
{
	float g = 0.5*(1.0+cos(gl_FragCoord.x/resolution.x*6.28));
	gl_FragColor = vec4(g,g,g,1);
}