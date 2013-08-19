import processing.opengl.*;
import javax.media.opengl.*;
import codeanticode.glgraphics.*;

GLSLShader theShader;

void setup() 
{
  size(800, 600, GLConstants.GLGRAPHICS);
  theShader = new GLSLShader(this, "varying_vert.glsl", "varying_frag.glsl");
  noStroke();
}

void draw()
{
  theShader.start();
  beginShape(QUADS);
    fill(255,0,0); vertex(0,0);
    fill(0,255,0); vertex(width,0);
    fill(0,0,255); vertex(width,height);
    fill(255,255,255); vertex(0,height);
  endShape();
  theShader.stop();
}
