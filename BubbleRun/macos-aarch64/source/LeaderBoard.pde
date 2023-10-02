class LeaderBoard
{
  FloatDict players;
  int maxNumPlayers = 5;
  int numPlayers = 0;
  int textPosStart = 50;
  int textX = 500;
  int textY = 10;
  int textJump = 35;
  String modeName = "";
  float scalar = 1.0;

  LeaderBoard()
  {
      players = new FloatDict();
  }

  void show()
  {
    //textJump = (int)((float)textJump * scalar);
    fill(96, 94, 96);
    rect(textX - 10, textY, (int)(scalar * 240), (int)(scalar * 250), 20);
    textSize(40*scalar);
    fill(0,0,0);
    text(modeName + ":", textX + (int)(30*scalar), textY + (int)(35*scalar));
    int inc = 1;
    players.sortValuesReverse();
    textSize(30*scalar);
    fill(255, 180, 200);
    for (String s : players.keys())
    {
      text(inc + ". " + s + ":   " + players.get(s), textX, (int)(textJump * scalar) * inc 
                                                              + (textY + (int)(45*scalar)));
      inc++;
    }
  }
  
  void setTextAndScore(String text, float score)
  {
    players.set(text, score);
    players.sortValuesReverse();
    if (players.size() > 5)
      players.remove(players.minKey());
  }
  
  boolean nameNecessary(float score)
  {
    if (players.size() < 5)
      return true;
    else
    {
      if (score > (float)players.get(players.minKey()))
        return true;
      else
        return false;
    }
  }
  void setLocation(int x, int y)
  {
    textX = x;
    textY = y;
  }
  void setModeName(String name)
  {
    modeName = name;
  }
  void scaleBoard(float scale)
  {
    scalar = scale;
  }

}
