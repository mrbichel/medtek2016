// Example 6 - Network diagram
// Builds a relational, weighted network graph

import de.bezier.data.sql.*;
SQLite db;


int screen_x = 800;
int screen_y = 600;


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
    
    IntDict temp = network.get(userInit);
    temp.sortValuesReverse();
     println(temp);
     
    displayInit(userInit, network);

}
  
void draw() {
  background(255);
  
}

void displayInit(String userCurrent, HashMap<String,IntDict> networkGraph){
 
 //for now, the current user is the first on in the network
 //let's get their retweet network
 IntDict retweets = networkGraph.get(userCurrent);
 
 //lets have 3 levels of strength/closeness, from weakest to strongest, i.e. ascending
 retweets.sortValues();
 
 //create an array of "weak" connections
 String[] weakUsers = new String[0];    // 3-5 posts
 int weakUsersLower = 1;
 int weakUsersUpper = 5;
 
 String[] mediumUsers = new String[0]; // 
 int mediumUserLower = 6;
 int mediumUsersUpper = 25;

 String[] strongUsers = new String[0]; // 10-25 posts
 int strongUsersLower = 26;
 int strongUsersUpper = 100000;
 
 String[] retweetUsers = retweets.keyArray();
 for(int i = 0; i < retweetUsers.length; i++){
   int strength = retweets.get(retweetUsers[i]);
   
   if(strength <= weakUsersUpper){
     weakUsers = append(weakUsers, retweetUsers[i]);
   }else if(strength <= mediumUsersUpper){
     mediumUsers = append(mediumUsers,retweetUsers[i]);
   }else if(strength <= strongUsersUpper){
     strongUsers = append(strongUsers, retweetUsers[i]);
   }else{
     //
   }     
 }//end for loop
  print("weakUsers:");
  println(weakUsers);
  print("medUsers:");
  println(mediumUsers);
  print("strongUsers:");
  println(strongUsers);

 //maximum radius would be the height of the screen minus textHeight
}

