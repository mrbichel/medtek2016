// Example 5 - User Poplularity Line Graph
// Plots the number of posts containing certain keywords for different parties over time

import de.bezier.data.sql.*;
import java.text.SimpleDateFormat;
import java.util.Date;
SQLite db;

int screen_x = 800;
int screen_y = 600;

int graph_x = 600;
int graph_y = 500;

int offset_x = (screen_x - graph_x) / 2;
int offset_y = (screen_y - graph_y) / 2;

int startTime;
int endTime;
int tweetCountTotal;

float usernamesWidth;

String keyword = "øko";

void drawAxis(){    
  stroke(0);
  strokeWeight(2);
  
  //draw the y axis. starting form the top left down to bottom left.
  line(offset_x, offset_y, offset_x, offset_y + graph_y);
  //draw the x axis. starting from the last point bottom left, to bottom right
  line(offset_x, offset_y + graph_y, offset_x + graph_x, offset_y + graph_y);    
}


class User {

  String name;
  int[] timestamps;
  int tweetCountTotal; 

  User(){
    name = "";
    timestamps = new int[0];
    tweetCountTotal = 0;
  }
  
  
  //called when we create new User object
  User(String tempName){
    
    //init the User object's variables
    name = tempName;
    timestamps = new int[0];
    tweetCountTotal = 0;

    String userQuery = "SELECT time FROM st WHERE text LIKE '%" + keyword + "%' and parti='"+ name + "' ORDER BY time ASC";

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

  userList.add(new User("DF"));
  userList.add(new User("V"));
  userList.add(new User("ALT"));  
}

void draw() {
  smooth();

  background(128);
  
  drawAxis();
  curveTightness(0.98);
  
  noFill();
  strokeWeight(2.0);
  strokeJoin(ROUND);
    
  User userFocus = userList.get(0);
  startTime = userList.get(0).timestamps[0];
  endTime = 0;
  tweetCountTotal = 0;

  for(int i=0; i<userList.size();i++) {
    startTime = min(userList.get(i).timestamps[0], startTime);
    endTime = max(userList.get(i).timestamps[userList.get(i).timestamps.length - 1], endTime);
    tweetCountTotal = max(userList.get(i).tweetCountTotal, tweetCountTotal) / 4;
  }
  //startTime = userFocus.timestamps[0];  
  //get the last time stamp in the timestamps array
  //endTime = userFocus.timestamps[userFocus.timestamps.length - 1];
  //userFocus.timestamps.length;

  textSize(20);
  usernamesWidth = 0.0;

  stroke(0,0,255);
  drawPopularity(userList.get(0));
  fill(0,0,255);
  writeUsername(userList.get(0).name);

  noFill();
  stroke(255,0,0);
  drawPopularity(userList.get(1));
  fill(255,0,0);
  writeUsername(userList.get(1).name);

  noFill();
  stroke(0,255,0);
  drawPopularity(userList.get(2));  
  fill(0,255,0);
  writeUsername(userList.get(2).name);

}



void drawPopularity(User user){
    
  //First user in the userList is who we set the graph scaled to... everyone else in the list is a comparison 
  
  int tweetCountCurrent = 0;
  //int tweetCountTotal = user.timestamps.length;
  beginShape();
  // unlike the previous example we bin the data in to intervals of one day 

  int day = startTime;

  //for each time stamp in the timestamp array
  for (int i=0; i < user.timestamps.length ; i++){
    //map the current timestamp
    int timeValue = user.timestamps[i];
    
    if (timeValue >= startTime && timeValue < endTime){
      

      // en meget nem måde at lave visulisering per dag i stedet for at vokse kontinuerligt
      // en bedre men lidt mere besværlig måde er at gå igennen dagene en af gangen og se hvor 
      // tweets der falder på dagene, på den måde vil sammeligningen være mere præcis 
      // og det vil være nemmere at sætte labels og akser på visualiseringen

      tweetCountCurrent++;
      if(timeValue - day > (24*60*60)) {
          tweetCountCurrent = 0;
          day = timeValue;
      }
      

      float vertex_x = map(timeValue, 
                          startTime, endTime, 
                          offset_x, offset_x + graph_x);
      float vertex_y = map(tweetCountCurrent, 
                          0, tweetCountTotal, 
                          offset_y + graph_y , offset_y);
      curveVertex(vertex_x, vertex_y);

    }
  } 
  endShape();

  fill(0);
  text(keyword + " over tid", offset_x, 30);
} 

void writeUsername(String name){   
  String username = "@" + name + " ";
  text(username, offset_x + usernamesWidth, offset_y + graph_y + offset_y/2);
  usernamesWidth += textWidth(username); 
}

// Øvelser:
// 1. tegn folketingsvalget eller andre begivenheder ind på tidlinjen for at sætte det ind en kontekts. 
// 2. definer selv tidsintervallet
// 3. sæt tal på de to akser

