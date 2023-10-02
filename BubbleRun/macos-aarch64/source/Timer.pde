class Timer
{
 long startTime ; // time in msecs that timer started
 long timeSoFar ; // use to hold total time of run so far, useful in
 // conjunction with pause and continueRunning
 boolean running ;
 int x, y ; // location of timer output

 Timer(int inX, int inY)
 {
 x = inX ;
 y = inY ;
 running = false ;
 timeSoFar = 0 ;
 }


 int currentTime()
 {
    if ( running )
       return ( (int) ( (millis() - startTime) / 1000.0) ) ;
    else
       return ( (int) (timeSoFar / 1000.0) ) ;
 }

 float currentTimeFloat()
 {
    if ( running )
       return ( ( (millis() - startTime) / 1000.0) ) ;
    else
       return ( (timeSoFar / 1000.0) ) ;
 }

 void start()
 {
 running = true ;
 startTime = millis() ;
 }
 void restart()
 // reset the timer to zero and restart, identical to start
 {
 start() ;
 }
 void reset()
 {
    timeSoFar = 0;
 }

 void pause()
 {
 if (running)
 {
  timeSoFar = millis() - startTime ;
  running = false ;
 }
 // else do nothing, pause already called
 }

 void continueRunning()
 // called after stop to restart the timer running
 // no effect if already running
{
 if (!running)
 {
  startTime = millis() - timeSoFar ;
 running = true ;
 }
 }

 void DisplayTime()
 {
  float theTime ;
  String output = "";
  int subtractor = 0;
  if (timeFloat < 10 && timeFloat > 0)
    subtractor = 33;
  else if (timeFloat ==0)
    subtractor = 99;

    

  theTime = currentTimeFloat();
  output = output + theTime;

 // println("output = " + output) ;
  strokeWeight(4);
  stroke(10);
  fill(96, 94, 96);
  rect(0,535,198-subtractor,70,0,24,0,0);
  noStroke();
  fill(500,200,500) ;
  textSize(70);
  text(output,x,y) ;
 }

}
