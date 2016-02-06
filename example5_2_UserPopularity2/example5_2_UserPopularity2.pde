// Example 5 - User Poplularity Line Graph
// Plots the number of posts a user has over time

import de.bezier.data.sql.*;
import java.text.SimpleDateFormat;
import java.util.Date;
SQLite db;



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

//the real values as bounds of the graph
int startTime;
int endTime;
int tweetCountTotal;

void drawAxis(){   //should be named drawAxes which is the proper plural of Axis, but that's a bit much...
  
  //set the line color. Greyscale number from 0 (black) to 255 (white)
  stroke(0);
  //set the line thickness / weight
  strokeWeight(2);
  
  //draw the y axis. starting form the top left down to bottom left.
  line(offset_x, offset_y, offset_x, offset_y + graph_y);
  //draw the x axis. starting from the last point bottom left, to bottom right
  line(offset_x, offset_y + graph_y, offset_x + graph_x, offset_y + graph_y);
     
}




// Create a User class that will contain the information about their posts from example 5.1
// To start having more users to compare to, we want to organise the User variables into a class
// so they are easier to organise, pull information from, and keep the data from before so we're not
// constaintly making new big SQL data calls.

// so, whenever we make a new user, we populate it with data from the DB and then store the user in 
// the ArrayList of User objects
class User {
  //User name that we're searching for
  String name;
  //full array of the time stamps from the query
  //we're looking to populate this and then map/scale it the appropriate axis
  int[] timestamps;
  int tweetCountTotal; 
  
  //class constructor
  //called when we create new User object
  User(String tempName){
    
    //init the User object's variables
    name = tempName;
    timestamps = new int[0];
    tweetCountTotal = 0;
        
    String userQuery = "SELECT time FROM st WHERE text LIKE '%" + name 
                        + "%' OR user='" + name + "' ORDER BY time ASC";

    //we're relying on the db global object/variable being created before we do any User object creation                        
    if ( db.connect() ) { 
      db.query(userQuery);
      while (db.next () ) {
        int time = db.getInt("time");
        timestamps = append(timestamps, time);
        tweetCountTotal++;      
        println("time:" + time);
      }
    }else{ // db connection fail
      println("DB connection fail");
      exit(); //quit the program.
    }


  }
}

ArrayList<User> userList;

void setup() { 
  // size definerer vores vindues størrelse
  size( screen_x, screen_y );

  db = new SQLite( this, "../data/st.db" );
  
  userList = new ArrayList<User>();

  User user1 = new User("larsloekke");
  userList.add(user1);
  User user2 = new User("Astridkrag");
  userList.add(user2);
  //same as above... less clear but also does the job, especially since we don't use the "user2" object anymore after adding it to the list
  userList.add(new User("SFpolitik"));  
}


void draw() {
  
  background(128);
  
  drawAxis();
  
  
  noFill();
  strokeWeight(5.0);
  strokeJoin(ROUND);
  
  User userFocus = userList.get(0); 

  startTime = userFocus.timestamps[0];  
  //get the last time stamp in the timestamps array
  endTime = userFocus.timestamps[userFocus.timestamps.length - 1];
  tweetCountTotal = userFocus.timestamps.length;

  stroke(0,0,255);
  drawPopularity(userList.get(0));
  stroke(255,0,0);
  drawPopularity(userList.get(1));
  stroke(0,255,0);
  drawPopularity(userList.get(2));
}



void drawPopularity(User user){
    
  //First user in the userList is who we set the graph scaled to... everyone else in the list is a comparison 

  int tweetCountCurrent = 0;
  //int tweetCountTotal = user.timestamps.length;

  beginShape();
  //for each time stamp in the timestamp array
  for (int i=0; i < user.timestamps.length ; i++){
    //map the current timestamp
    int timeValue = user.timestamps[i];
    
    if(timeValue < startTime){
      tweetCountCurrent++;      
    }else if (timeValue >= startTime && timeValue < endTime){
      
      //float vertex_x = map(timeValue, user1_firstTime, user1_lastTime, 0, width);
      float vertex_x = map(timeValue, 
                          startTime, endTime, 
                          offset_x, offset_x + graph_x);
      //float vertex_y = map(user1_tweetCountCurrent, 0, user1_tweetCountTotal, height, 0);
      float vertex_y = map(tweetCountCurrent, 
                          0, tweetCountTotal, 
                          offset_y + graph_y , offset_y);
      vertex(vertex_x, vertex_y);
      println("vertex:("+ vertex_x + ","+vertex_y+")"); 
      tweetCountCurrent++;
    }else{
      //out of time range, so can do nothing, or exit the loop early
    }
  } 
  endShape();

} 



