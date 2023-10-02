//==============================================================
// Simple button Class
class Button
{
  int xLoc=0, yLoc=0, width_=0, height_=0, rounded = 0;
  color buttonColor = color(0,0,0);
  String buttonText = "";
  int textSize = 1;
  color textColor = color(255,255,255);
  
  public void setSizeAndLocation(int x, int y, int w, int h)
  {
    xLoc = x;
    yLoc = y;
    width_ = w;
    height_ = h;
  }
  public void setSizeAndLocation(int x, int y, int w, int h, int roundedness)
  {
    xLoc = x;
    yLoc = y;
    width_ = w;
    height_ = h;
    rounded = roundedness;
  }
  public void setColors(int r, int g, int b, int textR, int textG, int textB)
  {
    buttonColor = color(r,g,b);
    textColor = color(textR,textG,textB);
  }
  public void setText (String text, int size)
  {
    textSize = size;
    buttonText = text;
  }
  public void drawButton()
  {
    fill(buttonColor);
    rect(xLoc, yLoc, width_, height_, rounded);
    textSize(textSize);
    fill(textColor);
    int textHeight = (int)(textAscent() + textDescent());
    text(buttonText, xLoc + (width_ - textWidth(buttonText))/2, yLoc + (height_ + textHeight)/2);
  }
  public boolean Pressed()
  {
    if (mousePressed && mouseX >= xLoc && mouseX <= xLoc+width_ && mouseY >= yLoc 
          && mouseY <= yLoc+height_)
      {return true;}  
    else
      {return false;}
  }
}
