uniform sampler2D texture;
uniform vec2 resolution;

#define PI 3.14

void main()
{
	vec2 center;
	center.x = 0.5*resolution.x;
	center.y = 0.5*resolution.y;
//	float gray = 1.0-mod( 2.0*distance(mouse, gl_FragCoord.xy)/resolution.x,0.1);
	float angle = atan( gl_FragCoord.y-center.y, gl_FragCoord.x-center.x);
	float d = distance(gl_FragCoord.xy, center)/resolution.x;


//	gl_FragColor = texture2D( texture, vec2( (0.5+0.5*cos(angle)), (0.5+0.5*sin(angle)) ) );
	gl_FragColor = texture2D( texture, vec2( cos(d), sin(d) ) );
}