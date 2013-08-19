import toxi.math.conversion.*;
import toxi.geom.*;
import toxi.math.*;
import toxi.geom.mesh2d.*;
import toxi.util.datatypes.*;
import toxi.util.events.*;
import toxi.geom.mesh.subdiv.*;
import toxi.geom.mesh.*;
import toxi.math.waves.*;
import toxi.util.*;
import toxi.math.noise.*;
import toxi.processing.*;


import processing.opengl.*;
import codeanticode.glgraphics.*;
import javax.media.opengl.*;
import processing.video.*;

// Model stored on GPU side
GLModel modelPlane;
GLTexture texDisplacement;
GLSLShader shaderDisplacement;
Capture cam;

// ----------------------------------------------------------------
void setup()
{
  size(800, 600, GLConstants.GLGRAPHICS);

//  cam = new Capture(this, 320, 240);
  String[] devices = Capture.list();
  println(devices);


  texDisplacement = new GLTexture(this, "milan.jpg");

  modelPlane = convertGLModel( (TriangleMesh) (new Terrain(100,100,5)).toMesh() );
  modelPlane.initTextures(1);
  modelPlane.setTexture(0,texDisplacement);

  shaderDisplacement = new GLSLShader(this, "displacement_vert.glsl", "displacement_frag.glsl");
}

// ----------------------------------------------------------------
void draw()
{
  background(0);
  translate(width/2, height/2,0);
  rotateX(mouseY*0.01);
  rotateY(mouseX*0.01);

  GLGraphics renderer = (GLGraphics)g;
  renderer.beginGL();
  renderer.gl.glPolygonMode( GL.GL_FRONT_AND_BACK, GL.GL_LINE );
  
  shaderDisplacement.start();
  shaderDisplacement.setTexUniform("texDisplacement", texDisplacement);
  shaderDisplacement.setFloatUniform("gridSize", 500);
    renderer.model(modelPlane);
  shaderDisplacement.stop();
  
  renderer.endGL();
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


