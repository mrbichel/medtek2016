// Example 6 - Network diagram
// Builds a relational, weighted network graph

import de.bezier.data.sql.*;
SQLite db;


int screen_x = 700;
int screen_y = 700;


//Initial username to graph
String userInit = "larsloekke";


// IntDict is a simple class to use String as a lookup for an int value. 
// String "keys" are associated with integer values.
// "user1@user2" -> 10      - user2 has retweeted user1 ten times
// "user2@user1" -> 2       - user1 has retweeted user2 two times
IntDict weightedEdges;


import java.util.Map;
// HashMap "network" is a HashMap of IntDict to store weighted directional relations.
// Example
// To store "User 1 was retweeted by user2 ten times, and by user3 four times",
// and "User 2 was retweeted by user1 twice and by user4 once".
// [
//  "user1" -> IntDict[("user2" -> 10), ("user3" -> 4), (...)]   ,
//  "user2" -> IntDict[("user1" -> 2), ("user4" -> 1), (...)]   ,
//  ... -> IntDict[...]
//  ]
HashMap<String,IntDict> network = new HashMap<String,IntDict>();




//HashMap of IntDicts

void createLocalGraph(String userCurrent){
  
  //clear each time for now, could be nice to continue to build a network in the background
  network.clear();
  
  String userRetweeted = "SELECT user FROM st WHERE text LIKE '%" + userCurrent 
                      + "%' ORDER BY time ASC";
  
  IntDict edgesCurrent = new IntDict();
                      
  if ( db.connect() ) {                      
    db.query(userRetweeted);
    
    while(db.next() ){
      //For each result in the DB, add the username of the tweeter to the IntDict
      String tweeter = db.getString("user");
      if (edgesCurrent.hasKey(tweeter) == true) {
        edgesCurrent.increment(tweeter);
      } else {
        //otherwise it's a new relationship, initialise the value to one
        edgesCurrent.set(tweeter,1);
      }
    }//end of db.next loop
    //additional exercise... change the SQL to do all the counting of user 
    //and then only add those numerical results to the edgesCurrent. Same result, different coding
  }//end of db.connect() block
  
  //add the created edges to the network
  network.put(userCurrent,edgesCurrent);
  
  
  //String userTweets = "SELECT text FROM st WHERE user='" + userCurrent + "' ORDER BY time ASC";                      
  //db.query(userTweets);
  
  
}


void setup() {
    db = new SQLite( this, "../data/st.db" );

    size(screen_x, screen_y);

    createLocalGraph(userInit);
      
    /*
    IntDict temp = network.get(userInit);
    temp.sortValuesReverse();
    println(temp);
    */
     
    displayInit(userInit, network);

}
  
void draw() {
  background(50);
  display(userInit, network);
}


//create arrays based on strength of user connections. Set the numbers for now.
String[] weakUsers;    // 1-5 posts
int weakUsersUpper = 5; 
String[] mediumUsers; // 6-25 post
int mediumUsersUpper = 25;
String[] strongUsers; // >25 posts

void displayInit(String userCurrent, HashMap<String,IntDict> networkGraph){
 
 //for now, the current user is the first on in the network
 //let's get their retweet network
 IntDict retweets = networkGraph.get(userCurrent);
 
 //lets have 3 levels of strength/closeness, from weakest to strongest, i.e. ascending
 // not really needed and having it scatter is sort of prettier/more interesting
 //retweets.sortValues();
 
 //create arrays based on strength of user connections. Set the numbers for now.
 weakUsers = new String[0];    // 1-5 posts
 mediumUsers = new String[0]; // 6-25 post
 strongUsers = new String[0]; // >25 posts
 
 String[] retweetUsers = retweets.keyArray();
 for(int i = 0; i < retweetUsers.length; i++){
   int strength = retweets.get(retweetUsers[i]);
   
   if(strength <= weakUsersUpper){
     weakUsers = append(weakUsers, retweetUsers[i]);
   }else if(strength <= mediumUsersUpper){
     mediumUsers = append(mediumUsers,retweetUsers[i]);
   }else if(strength > mediumUsersUpper){
     strongUsers = append(strongUsers, retweetUsers[i]);
   }else{
     //
   }     
 }//end for loop
}



//Global variables init:
//TODO: move them to the top, well commented
//how many pixels between the username and the bounding box


int boxPadding = 5;    

//weakUsers, mediumUsers, strongUsers
void display(String userCurrent, HashMap<String,IntDict> networkGraph){
  
  //display the userCurrent in the center. 
  //maximum radius would be the height of the screen minus textHeight
  //find the big circle around the weak users and divide the arcs from there  
  
  float slice = 360 / (float) weakUsers.length;
  float angle = 0;
  float radius = height/2 - 50;
    
  //for each user in weakUsers
  for(int i=0; i < weakUsers.length; i++){  
    float user_x = width/2 + cos(radians(angle))*(radius);
    float user_y = height/2 + sin(radians(angle))*(radius);
    angle = angle + slice;   
    userBox(user_x, user_y, weakUsers[i], 1);
  }
  
  slice = 360 / (float) mediumUsers.length;
  //for each user in mediumUsers
  for(int i=0; i < mediumUsers.length; i++){  
    float user_x = width/2 + cos(radians(angle))*(radius * 0.6);
    float user_y = height/2 + sin(radians(angle))*(radius * 0.6);
    angle = angle + slice;   
    userBox(user_x, user_y, mediumUsers[i], 1);
  }
  
  slice = 360 / (float) strongUsers.length;
  //for each user in mediumUsers
  for(int i=0; i < strongUsers.length; i++){  
    float user_x = width/2 + cos(radians(angle))*(radius * 0.3);
    float user_y = height/2 + sin(radians(angle))*(radius* 0.3);
    angle = angle + slice;   
    userBox(user_x, user_y, strongUsers[i], 1);
  }
  
  //draw the center user last (to cover the lines)
  userBox( width/2, height/2, userCurrent, 1);
}

//needs a bunch of fill variables set... will check and draw line from center
//todo use weight to effect color?
void userBox(float x, float y, String userName, int weight){
    
  textSize(12);
  float userNameHeight = textAscent() + textDescent();
  float userNameWidth = textWidth(userName);
  
  //draw (weighted) line to center of screen
  line(x, y, width/2, height/2);
  
  //draw box
  fill(255); //set rect to white
  rectMode(CENTER);
  textWidth(userName);
  //center rectangle 
  rect(x, y, userNameWidth+ 2*boxPadding, userNameHeight+ 2*boxPadding);
 
  //draw username  
  fill(100);
  textAlign(CENTER, CENTER);
  text(userName, x, y);

}
