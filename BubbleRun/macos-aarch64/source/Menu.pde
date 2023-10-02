class Menu
{
  int numOfModes= 3;
  Button buttons[] = new Button[numOfModes];

  Menu()
  {
    for (int i=0; i < numOfModes; i++)
      {buttons[i] = new Button();}
  }
  void show()
  {
    background(129, 143, 142);
    fill(66, 80, 85);
    rect(20, 10, 420, 365, 12);
   
    fill(255,255,255);
    textSize(70);
    text("Modes", 140, 80);

    fill(26, 65, 50);
    rect(440+20, 10, 520, 585, 12);
    
    fill(255,255,255);
    textSize(70);
    text("Leaderboards", 520, 65);
    textSize(50);
    text("w: up", 10, 420);
    text("a: left", 200, 420);
    text("s: down", 10, 480);
    text("d: right", 200, 480);

    for (int i=0; i < buttons.length; i++)
    {
      buttons[i].setSizeAndLocation(30,(i*85)+100, 400, 85);
      buttons[i].setColors(50*i,15,50*i,500,200,500);
      buttons[i].setText(modeNames[i], 50);
      buttons[i].drawButton();
    }
    boards[0].setLocation(480, 80);
    boards[1].setLocation(740, 80);
    boards[2].setLocation(610, 340);
    for (int i=0; i < modeNames.length; i++)
    {
      boards[i].scaleBoard(1);
      boards[i].setModeName(modeNames[i]);
      boards[i].show();
    }
    timer.DisplayTime();
    checkPressed();
  }
  int getMode()
    {return mode;}
  
  void reset()
    {
      mode = -1;
    }
  void checkPressed()
  {
    if (buttons[0].Pressed())
    {
      mode = 0;
      resetMode(mode);
    }
    else if (buttons[1].Pressed())
    {
      mode = 1;
      resetMode(mode);
    }
    else if (buttons[2].Pressed())
    {
      mode = 2;
      music.triggerAtkSin();
      resetMode(mode);
    }
  }
  
}
