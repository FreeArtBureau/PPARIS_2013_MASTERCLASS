/*

https://forum.processing.org/topic/cube-map

*/

import processing.opengl.*;
import javax.media.opengl.*;
import codeanticode.glgraphics.*;
import toxi.geom.*;
import toxi.geom.mesh.*;
import java.nio.IntBuffer;



TorusKnot torusKnot;
GLModel modelMesh;
CubeMap cubemap;
GLSLShader shader;

// ----------------------------------------------------------------
void setup()
{
  size(800,600,GLConstants.GLGRAPHICS);

  torusKnot = new TorusKnot(120,1,4);
  modelMesh = convertGLModel(torusKnot.mesh);

  cubemap = new CubeMap();
  cubemap.initGL( this, ((PGraphicsOpenGL) g).gl, "SaintPetersSquare2" );

  shader = new GLSLShader(this, "envmap_vert.glsl", "envmap_frag.glsl");
}

// ----------------------------------------------------------------
void draw()
{
  GLGraphics renderer = (GLGraphics)g;
  renderer.beginGL();

  background(0);

  //pointLight(200, 100, 10, mouseX, mouseY, 0);  
  //pointLight(0, 0, 200, mouseX, mouseY, 400);  

  translate(width/2, height/2,100);
  rotateX( radians(frameCount/2) );
  rotateY( radians(frameCount/2) );
//  rotateX( radians(50) );
//  rotateY( radians(50) );
  
//  renderer.gl.glPolygonMode( GL.GL_FRONT_AND_BACK, GL.GL_LINE );
  shader.start();
  modelMesh.render();
  shader.stop();

  renderer.endGL();
}

// ----------------------------------------------------------------
GLModel convertGLModel(TriangleMesh mesh)
{
  float[] vertices=mesh.getMeshAsVertexArray();
  int nbVertices = vertices.length/4;

  float[] normals=mesh.getVertexNormalsAsArray();
  
  GLModel m = new GLModel(this, nbVertices, TRIANGLES, GLModel.STATIC);
  
  m.beginUpdateVertices();
    for (int i = 0; i < nbVertices; i++) m.updateVertex(i, vertices[4*i], vertices[4*i+1], vertices[4*i+2]);
  m.endUpdateVertices(); 
  
  m.initNormals();
  m.beginUpdateNormals();
  for (int i = 0; i < nbVertices; i++) m.updateNormal(i, normals[4 * i], normals[4 * i + 1], normals[4 * i + 2]);
  m.endUpdateNormals();  

  return m;
}

// ----------------------------------------------------------------
void keyPressed()
{
  if (key == ' ')
    saveFrame("export.png");
}

