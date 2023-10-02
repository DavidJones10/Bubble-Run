import com.pdplusplus.*;
import com.portaudio.*;
Pd pd;
MyMusic music;

ArrayList<Bubble> bubbles = new ArrayList<Bubble>();
PVector character;
PVector coreVelo = new PVector(0,0);
PVector coreAccel = new PVector(0,0);
int coreSize = 50;

int scale[] = {0, 2, 3, 5, 7, 9, 10, 12, 14, 15, 17, 19, 21, 22, 24};
int transposition = 60;

float timeFloat = 0;
int seconds = 0;

Timer timer = new Timer(5, 595);

boolean gameLost = false;
int screen = 0; // Screen 0: loading screen; Screen 1: game; Screen 2: lost screen

int newBubbleX = 0;
int newBubbleY = 0;
boolean addBubb = false;
Menu menu;

String localName = new String();

int numKeys = 0;

LeaderBoard boards[] = new LeaderBoard[3];
String modeNames[] = new String[3];

Button toMenu;
Button playAgain;

int mode=0;
boolean nameEntered = false;
int bubblesToAdd;

//============================================================
void setup()
{
  size(1000,600);
  background(0);
  bubbles.clear();
  frameRate(60);
  localName = "";
  bubblesToAdd = 1;

  character = new PVector(width/2, height/2);
  for (int i=0; i < 3; i++)
  {
     bubbles.add(new Bubble(random(width), random(0,100)));
  }
  for (int i=0; i < boards.length; i++)
  {
    boards[i] = new LeaderBoard();
    modeNames[i] = new String();
  }
  modeNames[0] = "Standard";
  modeNames[1] = "Gravity";
  modeNames[2] = "Chase";

  menu = new Menu();
  music = new MyMusic();
  toMenu = new Button();
  playAgain = new Button();
  String path = this.dataPath("Game_Music_AvoidIO.wav");
  music.readFile(path);

  pd = Pd.getInstance(music);
  pd.start();
  menu.reset();
  gameLost = false;
}
//============================================================
void draw()
{
  background(50);
  seconds = timer.currentTime();
  timeFloat = timer.currentTimeFloat();
//========================= Before game screen
  if (screen == 0)
    {
      timer.reset();
      menu.show();
    }
//========================= During game screen
  else if (screen == 1)
  {
   timer.DisplayTime();
   if (mode == 0 || mode == 2)
   {
    if (seconds !=0 && seconds % 2 == 0)
     {
       if (!addBubb)
         bubbles.add(new Bubble(newBubbleX, newBubbleY));
       for (int i=0; i < bubbles.size(); i++)
        {bubbles.get(i).mag += .002;}
       addBubb = true;
     }
     else
       {addBubb=false;}
   }
   else
   {
    if (frameCount % 120 == 0)
      {
        if (!addBubb)
        {
          for (int i=0; i < (int)(seconds/2); i++)
            {bubbles.add(new Bubble((int)random(width), -20));}
          addBubb = true;
        }
        else
          addBubb = false;
      }
   }
   if (mode == 2)
   {
    float characterFreq = map(character.y, height, 0, 0, 2000);
    music.setFreqSin(characterFreq);
   }
   for (int i=0; i < bubbles.size(); i++)
   {
     bubbles.get(i).show();
     bubbles.get(i).update(mode);
   }
   collisions();
  }
  //========================= After game screen
  else
  {
    
    boards[mode].setLocation(250, 20);
    boards[mode].scaleBoard(1.9);
    boards[mode].setModeName(modeNames[mode]);
    boards[mode].show();
    toMenu.drawButton();
    playAgain.drawButton();
    if (boards[0].nameNecessary(timeFloat) && !nameEntered)
    {
      textSize(30);
      fill(255, 255, 255);
      textAlign(CENTER);
      text("INSERT 4 LETTER NAME BELOW:", 20, 40, 200, 200);
      textAlign(LEFT);
      textSize(50);
      text(localName, 20, 140, 200, 100);
    }
    afterLossLogic();
    timer.DisplayTime();
  }
}
//============================================================
public void dispose()
{
  pd.stop();
  println("Print this when sketch is stopped.");
  super.dispose();
}
//============================================================
void collisions()
{  
  character.add(coreVelo);

  FloatList distances = new FloatList();

  //float d  = character.dist(bubbles[0].pos);
  for (int i=0; i < bubbles.size(); i++)
    {
      distances.append(character.dist(bubbles.get(i).pos));
      if (distances.get(i) < bubbles.get(i).rad+coreSize/2)
        {
          music.triggerAtkSaw();
          music.triggerRelSin();
          timer.pause();
          screen = 2;
          nameEntered = false;
        }
      if (bubbles.get(i).pos.y > height)
        {bubbles.remove(i);}
    }
  fill(255,255,255,200);
  ellipse(character.x, character.y, coreSize,coreSize);
  fill(0,0,0,200);
  ellipse(character.x, character.y, coreSize/2,coreSize/2);
  update();
  newBubblePos();
}
//============================================================
void update()
{
  if (character.x < coreSize)
    {character.x = coreSize;}
  else if (character.x > width - coreSize)
    {character.x = width - coreSize;}
  if (character.y < coreSize)
    {character.y = coreSize+2;}
  else if (character.y > height - coreSize)
    {character.y = height - coreSize;}
}
//============================================================
void newBubblePos()
{
  if (character.x > 500)
    newBubbleX = (int)character.x - 400;
  else if (character.x < 500)
    newBubbleX = (int)character.x + 400;
  if (character.y > 300)
    newBubbleY = (int)character.y - 200;
  else if (character.y < 300)
    newBubbleY = (int)character.y + 200;
}
//============================================================
void keyPressed()
{
  if (screen == 1)
    {
      if (keyPressed && key == 'a')
        {coreVelo.x = -5;}
      if (keyPressed && key == 'd')
        {coreVelo.x = 5;}

      if (keyPressed && key == 'w')
        {coreVelo.y = -5;}
      if (keyPressed && key == 's')
        {coreVelo.y = 5;}
  }
  else if (screen == 2)
  {
    if (boards[mode].nameNecessary(timeFloat) && !nameEntered)
    {
      numKeys++;
      if (numKeys < 5)
      {
        localName += key;
      }
      if (localName.length() == 4)
      {
        boards[mode].setTextAndScore(localName, timeFloat);
        numKeys = 0;
        localName = "";
        nameEntered = true;
      }
    }
  }
}
//============================================================
void keyReleased()
{
  if (screen == 1)
  {
    if (key == 'a' || key == 'd')
      {coreVelo.x = 0;}
    if (key == 'w' || key == 's')
      {coreVelo.y = 0;}

  }

}
//============================================================
void afterLossLogic()
{
  toMenu.setSizeAndLocation(730,20,250,150,12);
  toMenu.setText("Return To Menu", 37);
  toMenu.setColors(65,124,105,255,255,255);
  playAgain.setSizeAndLocation(730,190,250,150,12);
  playAgain.setText("Play Again", 40);
  playAgain.setColors(80,104,88,255,255,255);
  if (toMenu.Pressed())
    if (nameEntered)
    {
      music.resetWav();
      screen = 0;
    }
    else
      text("PLEASE ENTER A NAME", 500, 555);
  else if (playAgain.Pressed())
    {
        if (nameEntered || !boards[mode].nameNecessary(timeFloat))
          {
            screen = 1; 
            if (mode == 2)
              music.triggerAtkSin();
            resetMode(mode);
          }
        else
          text("PLEASE ENTER A NAME", 500, 555);
    }
    
}
//============================================================
void resetMode(int Mode)
{
  screen = 1;
  bubblesToAdd = 1;
  coreVelo.x = coreVelo.y = 0;
  timer.restart();
  bubbles.clear();
  character.set(width/2, height/2);
  if (mode == 0 || mode ==2)
  {
    for (int i=0; i < 3; i++)
      {bubbles.add(new Bubble(random(width), random(0,100)));}
  }
  else
  {
    for (int i=0; i < 3; i++)
      {bubbles.add(new Bubble(random(width), -20));}
  }
}
