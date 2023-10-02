class Synth 
{
  Oscillator osc;
  Line line;
  double env = 0;
  boolean envBang;
  double freq = 440;
  float pan = .5;
  Synth() 
  {
    osc = new Oscillator();
    line = new Line();
  }
  double perform(double amp)
  {
    double out = 0; 
    if (envBang) 
      {env = line.perform(amp, 5);} 
     else 
     {
       env = line.perform(0, 1000);
     }

    if (env == amp)
      envBang = false;
    out = osc.perform(getFreq())*env;
    return out;
  }
  double getFreq()
    {return freq;}
  void setFreq(float frequency)
    {freq = frequency;}
  void triggerAtk()
    {envBang = true;}
  void setPan(float p)
    {pan = p;}
  float getPan()
    {return pan;}
  void free()
  {
      Oscillator.free(osc);
      Line.free(line);
  }
    
  

}
