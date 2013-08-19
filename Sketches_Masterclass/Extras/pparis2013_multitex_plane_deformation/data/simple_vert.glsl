void main()
{
	// gl_Position = output (write only)
	// gl_Vertex = input (local position)
	// gl_ModelViewProjectionMatrix = input (given by opengl)

	gl_Position =  gl_ModelViewProjectionMatrix * gl_Vertex;

	// gl_MultiTexCoord0 is input symbol (read)
	// gl_TexCoord[0] is output (write)
	gl_TexCoord[0] = gl_MultiTexCoord0;
}