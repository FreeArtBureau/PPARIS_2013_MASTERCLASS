import processing.opengl.*;
import javax.media.opengl.*;
import codeanticode.glgraphics.*;
import toxi.geom.mesh.*;


GLSLShader shaderDist;
GLGraphicsOffScreen offscreen;

Terrain grid;
GLModel modelPlane;
GLSLShader shaderDisplacement;

void setup() 
{
  size(800, 600, GLConstants.GLGRAPHICS);

  offscreen = new GLGraphicsOffScreen(this, width, height);
  shaderDist = new GLSLShader(this, "dist_sine_pulse_vert.glsl", "dist_sine_pulse_frag.glsl");


  grid = new Terrain(100, 100, 5);
  shaderDisplacement = new GLSLShader(this, "displacement_vert.glsl", "displacement_frag.glsl");
  modelPlane = convertGLModel( (TriangleMesh) grid.toMesh() );
  modelPlane.initTextures(1);
  modelPlane.setTexture(0, offscreen.getTexture());

  noStroke();
}

void draw()
{
  // Shader
  offscreen.beginDraw();
  shaderDist.start();
  shaderDist.setFloatUniform("t", millis()/1000.0);
  shaderDist.setVecUniform("resolution", float(width), float(height));
  offscreen.rect(0, 0, width, height);
  shaderDist.stop();
  offscreen.endDraw();

  // Mesh
  background(0);
  pushMatrix();
  translate(width/2, height/2, 0);
  rotateX(mouseY*0.01);
  rotateY(mouseX*0.01);

  GLGraphics renderer = (GLGraphics)g;
  renderer.beginGL();

  renderer.gl.glPolygonMode( GL.GL_FRONT_AND_BACK, GL.GL_LINE );
  modelPlane.setTexture(0, offscreen.getTexture());

  shaderDisplacement.start();
  shaderDisplacement.setTexUniform("texDisplacement", offscreen.getTexture());
  shaderDisplacement.setFloatUniform("gridSize", 500);
  renderer.model(modelPlane);
  shaderDisplacement.stop();

  // back to processing
  renderer.gl.glPolygonMode( GL.GL_FRONT_AND_BACK, GL.GL_FILL );
  renderer.endGL();

  popMatrix();
  float s=0.25;
  image(offscreen.getTexture(), 0, 0, s*width, s*height);
}

// ----------------------------------------------------------------
GLModel convertGLModel(TriangleMesh mesh)
{
  float[] vertices=mesh.getMeshAsVertexArray();
  int nbVertices = vertices.length/4;

  GLModel m = new GLModel(this, nbVertices, TRIANGLES, GLModel.STATIC);

  m.beginUpdateVertices();
  for (int i = 0; i < nbVertices; i++) m.updateVertex(i, vertices[4*i], vertices[4*i+1], vertices[4*i+2]);
  m.endUpdateVertices(); 

  return m;
}

