uniform float rnd;
uniform sampler2D tex;
uniform sampler2D mask;
uniform float t;
uniform vec2 resolution;

void main()
{
	vec2 uv = gl_TexCoord[0].st;

	 uv.y = uv.y+ 0.05*sin( 3.14*(t + gl_FragCoord.x/resolution.x)*3.0 );
	 uv.x = uv.x+ 0.02*sin( 3.14*(t + gl_FragCoord.y/resolution.y) );

	vec4 texColor = texture2D( tex, gl_TexCoord[0].st);
	vec4 maskColor = texture2D( mask,uv);
	gl_FragColor = texColor*maskColor;
}