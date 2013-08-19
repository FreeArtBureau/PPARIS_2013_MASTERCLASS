import processing.opengl.*;
import codeanticode.glgraphics.*;

GLSLShader shader;
GLTexture tex;
GLGraphicsOffScreen offscreen;
GLModel plane;

void setup()
{
  size(640,480, GLConstants.GLGRAPHICS);
  shader = new GLSLShader(this, "simple_vert.glsl", "simple_frag.glsl");
  tex = new GLTexture(this, "IMG_5685.JPG");

  offscreen = new GLGraphicsOffScreen(this, width,height);
  offscreen.beginDraw();
  background(0);
  offscreen.endDraw();

  plane = new GLModel(this, 4, QUADS, GLModel.STATIC);
  plane.beginUpdateVertices();
  plane.updateVertex(0, -width/2,-height/2,0);
  plane.updateVertex(1, width/2,-height/2,0);
  plane.updateVertex(2, width/2,height/2,0);
  plane.updateVertex(3, -width/2,height/2,0);
  plane.endUpdateVertices();
  
  plane.initTextures(2); // draw it with two textures
  for (int indexTexture=0;indexTexture<2;indexTexture++){
    plane.beginUpdateTexCoords(indexTexture);
    plane.updateTexCoord(0, 0,0);
    plane.updateTexCoord(1, 1,0);
    plane.updateTexCoord(2, 1,1);
    plane.updateTexCoord(3, 0,1);
    plane.endUpdateTexCoords();
  }
  
  plane.setTexture(0, tex);
  plane.setTexture(1, offscreen.getTexture());

}


void draw()
{
  offscreen.beginDraw();
  offscreen.noStroke();
//  fill(255);
//  if (mousePressed)
//    ellipse(mouseX,mouseY, 50,50);
  offscreen.background(0);
  offscreen.fill(255);
  offscreen.translate(width/2,height/2);
  offscreen.rotateX(frameCount*0.01);
  offscreen.rotateY(frameCount*0.01);
  offscreen.scale( 2*sin(frameCount*0.01) );
  offscreen.box(150);
  offscreen.endDraw();
  
  GLGraphics renderer = (GLGraphics)g;
  renderer.beginGL();
  background(0);
  shader.start();
  shader.setFloatUniform("rnd", random(0,1));
  shader.setTexUniform("tex", tex);
  shader.setTexUniform("mask", offscreen.getTexture());
  shader.setFloatUniform("t", millis()/1000.0);
  shader.setVecUniform("resolution", float(width), float(height));
  translate(width/2, height/2);
//  rotateZ( frameCount*0.01 );
//  rotateY( frameCount*0.01 );
  rotateZ( frameCount*0.01 );
  renderer.model( plane );

  shader.stop();
  renderer.endGL();
  
  float s = 0.2;
  scale(s);
  image(offscreen.getTexture(), 0,0);
}
