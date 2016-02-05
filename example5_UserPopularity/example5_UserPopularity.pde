// Example 5 - User Poplularity Line Graph
// Plots the number of posts a user has over time

import de.bezier.data.sql.*;
import java.text.SimpleDateFormat;
import java.util.Date;
SQLite db;


String user1 = "larsloekke";

//sort by time
//ASC|DESC stands for Ascending or Descending. Ascending is counting up, Descending is counting down.
String queryUser1 = "SELECT time FROM st WHERE user='" + user1 + "' ORDER BY time ASC";

int screen_x = 800;
int screen_y = 600;

//presume graph is centered aligned
//int graph_x = 600;
//int graph_y = 500;

int[] user1_timestamps;
int user1_firstTime;
int user1_lastTime;
int user1_tweetCountTotal;
int user1_tweetCountCurrent;

void setup() {

  user1_timestamps = new int[0];
  user1_tweetCountTotal = 0;
  user1_tweetCountCurrent = 0;
  
  // size definerer vores vindues størrelse
  size( screen_x, screen_y );

  db = new SQLite( this, "../data/st.db" );

  if ( db.connect() ) {
    db.query(queryUser1);

    while (db.next () ) {
      int time = db.getInt("time");
      user1_timestamps = append(user1_timestamps, time);
      user1_tweetCountTotal++;      
      Date date = new Date ((long) time * 1000);
      println("time:" + time);
    }
  }
  
  user1_firstTime = user1_timestamps[0];
  user1_lastTime = user1_timestamps[user1_timestamps.length - 1];
  
}


void draw() {
  
  background(128);
  
  user1_tweetCountCurrent = 0;
  
  //can add fill later, with the co-ords of the x-axis as the base.
  noFill();
  strokeWeight(5.0);
  strokeJoin(ROUND);

  beginShape();
  //map graph width
  
  //map(value, start1, stop1, start2, stop2)
  //map(timeValue, user1_firstTime, user1_lastTime, 0, width);
  //map(user1_tweetCountCurrent, 0, user1_tweetCountTotal, 0, height);
  
  //for each time stamp in the timestamp array
  for (int i=0; i < user1_timestamps.length ; i++){
    //map the current
    int timeValue = user1_timestamps[i];
    float vertex_x = map((float)timeValue, (float)user1_firstTime, (float)user1_lastTime, 0, width);
    float vertex_y = map((float)user1_tweetCountCurrent, 0, user1_tweetCountTotal, height, 0);
    vertex(vertex_x, vertex_y);    
    println("vertex:("+ vertex_x + ","+vertex_y+")"); 
    user1_tweetCountCurrent++;
  } 
  
  endShape();
  
 
}
