//uniform mat4 projmodelviewMatrix;
uniform mat4 modelviewMatrix;
uniform mat4 projmodelviewMatrix;
attribute vec4 inVertex;

void main()
{
//	gl_Position = ftransform();
//  gl_Position = projmodelviewMatrix * inVertex;

  // Vertex in clip coordinates
  gl_Position = projmodelviewMatrix * inVertex;

}