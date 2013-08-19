uniform vec2 mouse;
uniform vec2 resolution;

void main()
{
//	float gray = 1.0-mod( 2.0*distance(mouse, gl_FragCoord.xy)/resolution.x,0.1);
	float gray = 1.0-2.0*distance(mouse, gl_FragCoord.xy)/resolution.x;
	gl_FragColor = vec4(gray,gray,gray,1);
}