import processing.opengl.*;
import codeanticode.glgraphics.*;
import toxi.math.waves.*;
import toxi.geom.*;
import toxi.geom.mesh.*;
import javax.media.opengl.*;

GLModel meshModel;
CubeMap cubemap;
GLSLShader shader;


void setup()
{
  size(800, 600, GLConstants.GLGRAPHICS);
  randomizeModel();

  cubemap = new CubeMap();
  cubemap.initGL( this, ((PGraphicsOpenGL) g).gl, "SaintPetersSquare2" );
  shader = new GLSLShader(this, "envmap_vert.glsl", "envmap_frag.glsl");
}

void draw()
{
  background(0);
  translate(width/2, height/2,0);
  rotateX(mouseY*0.01);
  rotateY(mouseX*0.01);

  GLGraphics renderer = (GLGraphics)g;
  renderer.beginGL();
//  renderer.gl.glPolygonMode( GL.GL_FRONT_AND_BACK, GL.GL_LINE );

  shader.start();
  renderer.model(meshModel);
  shader.stop();
  
  renderer.endGL();
}

TriangleMesh randomizeMesh() 
{
  float[] m=new float[8];
  for(int i=0; i<8; i++) {
    m[i]=(int)random(9);
  }
  SurfaceMeshBuilder b = new SurfaceMeshBuilder(new SphericalHarmonics(m));
  return (TriangleMesh)b.createMesh(null,80, 60);
}

GLModel convertGLModel(TriangleMesh mesh)
{
  float[] vertices=mesh.getMeshAsVertexArray();
  float[] normals=mesh.getVertexNormalsAsArray();
  int nbVertices = vertices.length/4;
  
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

void randomizeModel()
{
  meshModel = convertGLModel( randomizeMesh() );
}

void keyPressed()
{
  if (key == ' ')
    randomizeModel();
}


