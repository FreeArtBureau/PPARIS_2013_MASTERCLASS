import processing.opengl.*;
import javax.media.opengl.*;
import codeanticode.glgraphics.*;
import toxi.geom.*;
import toxi.geom.mesh.*;
import toxi.processing.*;


TorusKnot torusKnot;
ToxiclibsSupport gfx;
GLModel modelMesh;

void setup()
{
  size(800,600,GLConstants.GLGRAPHICS);

  torusKnot = new TorusKnot(120,2,5);
  
  modelMesh = convertGLModel(torusKnot.mesh);
  
  gfx = new ToxiclibsSupport(this);
}

void draw()
{
  GLGraphics renderer = (GLGraphics)g;
  renderer.beginGL();

  background(0);
  translate(width/2, height/2);

  pointLight(51, 102, 126, mouseX, mouseY, 200);  

  rotateX( map(mouseY,0,height,-PI,PI) );
  rotateY( map(mouseX,0,width,-PI,PI) );
  modelMesh.render();

//  renderer.gl.glPolygonMode( GL.GL_FRONT_AND_BACK, GL.GL_LINE );
     // pointLight(51, 102, 126, lightX, lightY, lightZ);  
  
//    renderer.model(modelMesh);
  
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
