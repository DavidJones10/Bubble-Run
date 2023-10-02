class MyMusic extends PdAlgorithm 
{
  int voices = 12;
  Synth synths[] = new Synth[voices];
  Line line = new Line();
  Phasor saw = new Phasor();
  Oscillator sine = new Oscillator();
  Reverb rev = new Reverb();
  Line sineLine = new Line();
  float oscFreq = 440;
  float amp = 1;
  double sawEnv = 0;
  double sineEnv = 0;
  double sawAmp = .2;

  double envelopes[] = new double[12];
  boolean envBang = false;
  boolean bangs[] = new boolean[12];
  boolean isArray = false;
  float fundamental = 10;
  int interval = 1;
  int currentVoice = 0;
  SoundFiler wav = new SoundFiler();
  double[] soundFile;
  double fileSize;
  int counter = 0;
  double fileVolume = .1;
  boolean sineBang = false;
  float sineFreq;
 
   
  void readFile(String file) 
  {
    fileSize = wav.read(file);
    soundFile = wav.getArray();
  }
  void resetWav()
  {
    counter = 0;
  }

  MyMusic()
  {
     for (int i=0; i < synths.length; i++)
      {synths[i] = new Synth();}
     rev.setVolume(100);
  }
  
  void runAlgorithm(double in1, double in2)
  {
   if (screen == 1 || screen == 2)
   {
      if (envBang)
        sawEnv = line.perform(sawAmp,1);
      else 
        sawEnv = line.perform(0, 1000);
      if (sawEnv ==sawAmp)
        envBang = false;
      
      if (sineBang)
        sineEnv = sineLine.perform(.08,1);
      else 
        sineEnv = sineLine.perform(0, 1000);

      double sawOut = saw.perform(500*sawEnv)*sawEnv;
      double sineOut = sine.perform(sineFreq)*sineEnv;
      double outL = 0;
      double outR = 0;
      for (int i = 0; i < voices; i++)
      {
        double out = synths[i].perform(amp);
        float panning = synths[i].getPan();
        outL += out * (1-panning) + sineOut;
        outR += out * panning + sineOut;
      }
       outL *= (1.0/voices);
       outR *= (1.0/voices);
       outputL = outL+sawOut+rev.perform(outL);
       outputR = outR+sawOut+rev.perform(outR);
    }
    else if (screen == 0)
    {
      if(counter != fileSize)
      {
          outputL = soundFile[counter++] * fileVolume;
          outputR = soundFile[counter++] * fileVolume;
          if(counter == fileSize) counter = 0;
      }
    }
  }
  
  synchronized void setPan(float p)
  {
    synths[currentVoice].setPan(p);
  }

  synchronized float getFreq ()
    {return oscFreq;}
  
  synchronized void setFreq (float f1)
  {
    synths[currentVoice].setFreq(f1);
    fundamental = f1;
    notify();
  }
  
  synchronized void setInterval(int inter)
    {interval = inter;}
  
  synchronized float getAmp ()
    {return amp;}
  
  synchronized void setAmp(float am)
    {amp = am;}
  
  synchronized void triggerAtk()
    {
      synths[currentVoice].triggerAtk();
      currentVoice = (currentVoice +1) % voices;
    }
  
  synchronized void useArray()
    {isArray = true;}
  
  synchronized void triggerAtkSaw() 
  {
     envBang = true;
  }
  synchronized void triggerAtkSin()
  {
    sineBang = true;
  }
  synchronized void triggerRelSin()
  {
    sineBang = false;
  }
  synchronized void setFreqSin(float freq)
  {
    sineFreq = freq;
  }
  
  void free()
  {
    for (int i=0; i < synths.length; i++)
    {
      synths[i].free();
    }
    Oscillator.free(sine);
    Phasor.free(saw);
    SoundFiler.free(wav);
  }
}
