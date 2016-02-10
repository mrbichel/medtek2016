// Example 5 - User Poplularity Line Graph
// Plots the number of posts a user has over time

import de.bezier.data.sql.*;
import java.text.SimpleDateFormat;
import java.util.Date;
SQLite db;


// can be nice to define global variables at the top of the program
// this way if we need to make quick changes to things that we might expect we might need, in this case screen width
// we can quickly change it. 
// what we want to do through the rest of the program is also make sure that we only reference the variables by name,
// instead of inserting a "hard coded" value later. That is, we don't want be using the bare number "800" else where in the program
// because if we need to make the change later, then we'd have to go and look through the code. Which sucks.
int screen_x = 800;
int screen_y = 600;

// Similarly, we define other static graph width/height values here.
// Allow the graph to be smaller than the screen, so we have space to add post count and dates
// We currently define the graph is centered aligned, and the code below reflects this. if we changed the code below
// to allow different offsets, then we'd also want to change this comment to describe something else. Again, for ease of future changes.
int graph_x = 600;
int graph_y = 500;

//The offset is how much space/padding we have between the edge of the screen 
//and the graph, which is centered for now
int offset_x = (screen_x - graph_x) / 2;
int offset_y = (screen_y - graph_y) / 2;

//the real values as bounds of the graph. That is, the un-mapped/un-scaled time values.
int startTime;
int endTime;
int tweetCountTotal;

//this variable helps us track our current x-coordinate whilst writing usernames
float usernamesWidth;



// Draw the Axes of the graph.
// Should be named drawAxes which is the proper plural of Axis, 
// pronounced how one might expect axis pluralised would sound,
// not like a pair of axes for chopping. But that's some pretty obscure English...
void drawAxis(){    
  //set the line color. Greyscale number from 0 (black) to 255 (white)
  stroke(0);
  //set the line thickness / weight. Play with this to find different looks. Can be a float.
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

// We also create a class so that the information belonging to each User is "held together" or related strongly
// in each. That is, Name, timestaps and tweetcountTotal will all then be contained in a single User object.
// Another way of hold this data is in seperate arrays, but then we have to be more careful when referencing/pulling 
// the information out of each different data structure...

// So, whenever we make a new user, we populate it with data from the DB and then store the user in 
// the ArrayList of User objects

// This first line defines the next code block to be about a new object class, that is named 'User'
class User {
  //We now define the list of properties that give our new User object it's "User-ness"
  //First thing a User has is a name 
  String name;
  //Second thing a User has is a bunch of tweets that occured at a certain time.
  //For our graph, we only need to know the time a post was made, not the content/text of the post.
  //So for this sketch, we only need an array of ordered timestamps of tweets, not the tweets themselves.
  //full array of the time stamps from the db query
  int[] timestamps;

  //Third property is more for convenience. We could calculated the total number of tweets each time by looking at timestamp.legth()
  //But it's also nice and clear in later code to call the the tweetCountTotal directly.
  int tweetCountTotal; 
  
  // we could also include more properties for the User, such as a display color, or the array of tweets etc etc.
  // but for now, let's just stick to the timestamps
  
  
  
  //Class constructor
  //Once we've defined an Object by stating a bunch of properties, was can then define how a new object is to be actually
  //created at runtime. 
  //The simplest way would be to create a User object with default values;

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
      break;
    }
    
    if(tweetCountCurrent > tweetCountTotal){
      break;
    }   
    
  } 
  endShape();
} 

void writeUsername(String name){   
  String username = "@" + name + " ";
  text(username, offset_x + usernamesWidth, offset_y + graph_y + offset_y/2);
  usernamesWidth += textWidth(username); 
}


