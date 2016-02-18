// Example 5 - User Poplularity Line Graph

// Når vi skal se historierne i vores data er det ofte relevant at visualisere udvikling over tid
// Her et simpelt eksempel hvor vi ser over tid hvor mange gange en politiker bliver nævnt af andre 


import de.bezier.data.sql.*;
import java.text.SimpleDateFormat;
import java.util.Date;

SQLite db;

String user1 = "larsloekke";

// sort by time
// ASC|DESC stands for Ascending or Descending. Ascending is counting up, Descending is counting down.
String queryUser1 = "SELECT time FROM st WHERE text LIKE '%" + user1 + "%' ORDER BY time ASC";

int screen_x = 800;
int screen_y = 600;

//Allow the graph to be smaller than the screen, so we have space to add post count and dates
//presume graph is centered aligned
int graph_x = 600;
int graph_y = 500;

//The offset is how much space/padding we have between the edge of the screen and the graph
//presume it's centered for now
int offset_x = (screen_x - graph_x) / 2;
int offset_y = (screen_y - graph_y) / 2;

//full array of the time stamps from the query
//we're looking to populate this and then map/scale it the appropriate axis
int[] user1_timestamps;


void drawAxes(){  
  stroke(0);
  strokeWeight(2);
  
  //draw the y axis. starting form the top left down to bottom left.
  line(offset_x, offset_y, offset_x, offset_y + graph_y);
  //draw the x axis. starting from the last point bottom left, to bottom right
  line(offset_x, offset_y + graph_y, offset_x + graph_x, offset_y + graph_y);
}

void setup() {

  user1_timestamps = new int[0];
  
  // size definerer vores vindues størrelse
  size( screen_x, screen_y );

  db = new SQLite( this, "../data/st.db" );

  if ( db.connect() ) {
    db.query(queryUser1);

    while (db.next () ) {
      int time = db.getInt("time");
      user1_timestamps = append(user1_timestamps, time);
      //Date date = new Date ((long) time * 1000);
      println("time:" + time);
    }
  }
  
}

// 

void draw() {
  
  background(128);
  
  drawAxes();
  
  //can add fill later, with the co-ords of the x-axis as the base.
  noFill();
  strokeWeight(5.0);
  strokeJoin(ROUND);
  beginShape();
  //map graph width
  
  //init variables for the loop below, and to make things a bit more readable
  int user1_tweetCountCurrent = 0;  
  int user1_tweetCountTotal = user1_timestamps.length;
  int user1_firstTime = user1_timestamps[0];

  //get the last time stamp in the timestamps array
  int user1_lastTime = user1_timestamps[user1_timestamps.length - 1];

  //for each time stamp in the timestamps array
  for (int i=0; i < user1_timestamps.length ; i++){
    //map the current timestamp
    int timeValue = user1_timestamps[i];
    
    //float vertex_x = map(timeValue, user1_firstTime, user1_lastTime, 0, width);
    float vertex_x = map(timeValue, user1_firstTime, user1_lastTime, offset_x, offset_x + graph_x);
    //float vertex_y = map(user1_tweetCountCurrent, 0, user1_tweetCountTotal, height, 0);
    float vertex_y = map(user1_tweetCountCurrent, 0, user1_tweetCountTotal, offset_y + graph_y , offset_y);
    vertex(vertex_x, vertex_y);
    user1_tweetCountCurrent++;
  } 
  
  endShape();
  
 
}
