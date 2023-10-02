class Bubble
{
  PVector pos;
  color c;
  float rad;
  PVector velo;
  PVector accel;
  PVector gravity;
  float topSpeed;
  String text ="";
  boolean ceilOrFloor = false;
  boolean collDetected = false;
  float mag = .02;
  
  Bubble (float x, float y)
  {
    this.c = color(random(255), random(255), random(255), 200);
    this.pos = new PVector(x,y);
    if (mode==2)
      this.velo = new PVector(random(1), 0);
    else 
      this.velo = new PVector(random(-4, 4), random(4));

    this.rad = random(20,50);
    topSpeed = 2;
    mag = .02;
    
  }
  void setText(String txt)
  {
    text = txt;
  }
  void show()
  {
    noStroke();
    fill(c);
    ellipse(pos.x, pos.y, rad*2, rad*2);
    fill(0,0,0,200);
    textSize(20);
    text(text, pos.x, pos.y);
  }
  void update(int mode_)
  {
    switch (mode_)
    {
      case 0:
        mode0update();
        break;
      case 1:
        mode1update();
        break;
      case 2:
        mode2update();
        break;
    }
  }
    //pos.add(PVector.random2D().mult(4));
  void randomColor() 
  {
    c = color(random(255), random(255), random(255), 200);
  } 
  void mode0update()
  {
    collDetected = false;
    if (pos.x < rad)
      {
        pos.x = rad;
        velo.x *= -1;
        collDetected = true;
        ceilOrFloor = false;
      }
      else if (pos.x > width - rad)
      {
        pos.x = width - rad;
        velo.x *= -1;
        collDetected = true;
        ceilOrFloor = false;
      }
      if (pos.y < rad)
      {
        pos.y = rad;
        velo.y *= -1;
        collDetected = true;
        ceilOrFloor = true;
      }
      else if (pos.y > height - rad)
      {
        pos.y = height - rad;
        velo.y *= -1;
        collDetected = true;
        ceilOrFloor = true;
      }
      pos.add(velo);
      if (collDetected)
      {
        int note = 0;
        randomColor();
        if (!ceilOrFloor)
          note = scale[(int)map(pos.y, height, 0, 0, scale.length)] + transposition;
        else
          note = scale[(int)random(0,14)] + (transposition + 12*(int)random(-2,2));
        float freq = (float)pd.mtof(note);
        music.setPan(map(pos.x, 0, width, 0, 1));
        music.setFreq(freq);
        music.triggerAtk();
      }
  }

  void mode1update()
  {
    collDetected = false;
    gravity = new PVector(0,0.01);
    velo.add(gravity);
    pos.add(velo);
    if (pos.x < rad)
    {
      pos.x = rad;
      velo.x *= -1;
      collDetected = true;
      ceilOrFloor = false;
    }
    else if (pos.x > width - rad)
    {
      pos.x = width - rad;
      velo.x *= -1;
      collDetected = true;
      ceilOrFloor = false;
    }
    if (pos.y < rad)
    {
      collDetected = true;
      ceilOrFloor = true;
    }
    else if (pos.y > height - rad)
    {
      collDetected = true;
      ceilOrFloor = true;
    }
    pos.add(velo);
    if (collDetected)
    {
      int note = 0;
      randomColor();
      if (!ceilOrFloor)
        note = scale[(int)map(pos.y, height, 0, 0, scale.length)] + transposition;
      else
        note = scale[(int)random(0,14)] + (transposition + 12*(int)random(-2,2));
      float freq = (float)pd.mtof(note);
      music.setPan(map(pos.x, 0, width, 0, 1));
      music.setFreq(freq);
      music.triggerAtk();
      ceilOrFloor = false;
      collDetected = false;
    }

  }

  void mode2update()
  {
    collDetected = false;
    PVector accel = PVector.sub(character,pos);
    accel.setMag(mag);
    velo.add(accel);
    velo.limit(topSpeed);
    pos.add(velo);

    if (pos.x < rad)
    {
      pos.x = rad;
      velo.x *= -.5;
      collDetected = true;
      ceilOrFloor = false;
    }
    else if (pos.x > width - rad)
    {
      pos.x = width - rad;
      velo.x *= -.5;
      collDetected = true;
      ceilOrFloor = false;
    }
    if (pos.y < rad)
    {
      pos.y = rad;
      velo.y *= -.5;
      collDetected = true;
      ceilOrFloor = true;
    }
    else if (pos.y > height - rad)
    {
      pos.y = height - rad;
      velo.y *= -.5;
      collDetected = true;
      ceilOrFloor = true;
    }
    pos.add(velo);
    if (collDetected)
    {
      int note = 0;
      randomColor();
      if (!ceilOrFloor)
        note = scale[(int)map(pos.y, height, 0, 0, scale.length)] + transposition;
      else
        note = scale[(int)random(0,14)] + (transposition + 12*(int)random(-2,2));
      float freq = (float)pd.mtof(note);
      music.setPan(map(pos.x, 0, width, 0, 1));
      music.setFreq(freq);
      music.triggerAtk();
    }
  }
}
