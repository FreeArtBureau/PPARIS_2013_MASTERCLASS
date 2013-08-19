// --------------------------------------------------------
import codeanticode.glgraphics.*;
import codeanticode.gsvideo.*;
import processing.opengl.*;
import toxi.geom.*;
import toxi.geom.mesh.*;
import toxi.processing.*;
import javax.media.opengl.*;

boolean modelFilled = true;

TriangleMesh sphereMesh;
GLModel sphereModel;
GLGraphicsOffScreen offscreenDisp;
GLSLShader shaderDisp;
GLSLShader shaderModel;
GLSLShader shaderDither;
ToxiclibsSupport gfx;
GSCapture cam;
GLTexture texCam;

GLGraphicsOffScreen offscreenModel;

// --------------------------------------------------------
void captureEvent(GSCapture cam) 
{
  cam.read();
}

// --------------------------------------------------------
void setup()
{
  size(800, 600, GLConstants.GLGRAPHICS);

  cam = new GSCapture(this, 640, 480);
  texCam = new GLTexture(this);
  cam.setPixelDest(texCam);     
  cam.start();


  offscreenDisp = new GLGraphicsOffScreen(this, width/4, height/4);
  shaderDisp = new GLSLShader(this, "dist_sine_pulse_vert.glsl", "dist_sine_pulse_frag.glsl");
  shaderModel = new GLSLShader(this, "displacement_vert.glsl", "displacement_frag.glsl");
  shaderDither = new GLSLShader(this, "dither_vert.glsl", "dither_frag.glsl");

  // Creating the triangle mesh (CPU side)
  //sphereMesh=(TriangleMesh)new Sphere(new Vec3D(), 60).toMesh(20);
  //calcTextureCoordinates(sphereMesh);

  // Sending the model to GPU thanks to GLModel
  sphereModel = createSphereGLModel(50, 150);

  sphereModel.initTextures(1);
  sphereModel.setTexture(0, texCam /*offscreenDisp.getTexture()*/);
  sphereModel.updateTexCoords(0, texCoords);

  // Sets the normals.
  sphereModel.initNormals();
  sphereModel.updateNormals(normals);

  offscreenModel = new GLGraphicsOffScreen(this, width, height);
  

  gfx=new ToxiclibsSupport(this);
}

// --------------------------------------------------------
void draw()
{

  // Shader
/*  offscreenDisp.beginDraw();
  shaderDisp.start();
  shaderDisp.setFloatUniform("t", millis()/1000.0);
  shaderDisp.setVecUniform("resolution", float(offscreenDisp.width), float(offscreenDisp.height));
  offscreenDisp.rect(0, 0, offscreenDisp.width, offscreenDisp.height);
  shaderDisp.stop();
  offscreenDisp.endDraw();
*/

  if (texCam.putPixelsIntoTexture()) {


  // Model
  //  sphereModel.setTexture(0, offscreenDisp.getTexture());
  offscreenModel.beginDraw();
  offscreenModel.beginGL();
  offscreenModel.background(0);
  //GLGraphics renderer = (GLGraphics)g;
//  offscreenModel.beginGL();
//  renderer.beginGL();
  // renderer.gl.glPolygonMode( GL.GL_FRONT_AND_BACK, !modelFilled ? GL.GL_LINE : GL.GL_FILL );
  offscreenModel.stroke(255);
  offscreenModel.noFill();
  offscreenModel.translate(width/2, height/2, 200);
  offscreenModel.rotateY( mouseX*0.01 );
  offscreenModel.rotateX( mouseY*0.01 );
  shaderModel.start();
  shaderModel.setTexUniform("texDisplacement", texCam /*offscreenDisp.getTexture()*/);
  shaderModel.setFloatUniform("amplitude", map( mouseX,0,width,0,50 ) );
  //renderer.model(sphereModel);
  offscreenModel.model(sphereModel);

/*  renderer.gl.glPolygonMode( GL.GL_FRONT_AND_BACK, GL.GL_FILL );
  renderer.gl.glFrontFace(GL.GL_CW);
  renderer.gl.glCullFace(GL.GL_FRONT); 
  renderer.gl.glEnable(GL.GL_CULL_FACE);
*/
  shaderModel.start();
  offscreenModel.endGL();
  offscreenModel.endDraw();
  //renderer.endGL();
  //  gfx.model(sphereMesh);
  }

  GLGraphics renderer = (GLGraphics)g;
  renderer.beginGL();
  shaderDither.start(); // Enabling shader.
  shaderDither.setFloatUniform("scale", 1.0);
  shaderDither.setTexUniform("texture", offscreenModel.getTexture());
  

  beginShape(QUADS);
  textureMode(NORMALIZED);
  texture(offscreenModel.getTexture());
  vertex(0, 0, 0, 0);
  vertex(2*width, 0, 1, 0); // why 2 ????
  vertex(2*width, 2*height, 1, 1); 
  vertex(0, 2*height, 0, 1);  
  endShape();
  
  shaderDither.stop();
  renderer.endGL();


  
  float s=0.25;
  //image(offscreenDisp.getTexture(), 0, 0, s*width, s*height);
  image(offscreenModel.getTexture(), 0, 0, s*width, s*height);
}

// ----------------------------------------------------------------
GLModel convertGLModel(TriangleMesh mesh)
{
  float[] vertices=mesh.getMeshAsVertexArray();
  int nbVertices = vertices.length/4;

  GLModel m = new GLModel(this, nbVertices, TRIANGLES, GLModel.STATIC);

  // Set up vertices
  m.beginUpdateVertices();
  for (int i = 0; i < nbVertices; i++) m.updateVertex(i, vertices[4*i], vertices[4*i+1], vertices[4*i+2]);
  m.endUpdateVertices(); 

  // Setup texture
  m.initTextures(1);
  m.setTexture(0, offscreenDisp.getTexture());

  // Setup tex coordinates
  m.beginUpdateTexCoords(0);
  int indexVertex = 0;
  int indexFace = 0;
  for (Face f : mesh.getFaces()) 
  {
    m.updateTexCoord(indexVertex++, f.uvA.x, f.uvA.y);
    m.updateTexCoord(indexVertex++, f.uvB.x, f.uvB.y);
    m.updateTexCoord(indexVertex++, f.uvC.x, f.uvC.y);
  }

  m.endUpdateTexCoords();

  return m;
}

// ----------------------------------------------------------------
//http://forum.processing.org/topic/drawing-textured-sphere-with-toxiclibs
//
// this function computes texture coordinates
// for the generated earth mesh
void calcTextureCoordinates(TriangleMesh mesh) 
{
  for (Face f : mesh.getFaces()) {
    f.uvA=calcUV(f.a);
    f.uvB=calcUV(f.b);
    f.uvC=calcUV(f.c);
  }
}

// ----------------------------------------------------------------
// compute a 2D texture coordinate from a 3D point on a sphere
// this function will be applied to all mesh vertices
Vec2D calcUV(Vec3D p) 
{
  Vec3D s=p.copy().toSpherical();
  Vec2D uv=new Vec2D(s.y/(TWO_PI), 1-(s.z/PI+0.5));
  // make sure longitude is always within 0.0 ... 1.0 interval
  if (uv.x<0) uv.x+=1;
  else if (uv.x>=1) uv.x-=1;
  return uv;
}


void keyPressed()
{
  if (key == ' ')
    modelFilled = !modelFilled;
}

