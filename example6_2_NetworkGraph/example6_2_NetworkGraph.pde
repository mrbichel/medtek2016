// Example 6 - Network diagram
// Builds a relational, weighted network graph, localiazed around a single user
// 

import de.bezier.data.sql.*;
SQLite db;

int screen_x = 700;
int screen_y = 700;

//Initial username to graph
String userInit = "SFpolitik";
//another examples
//String userInit = "larsloekke";
//String userInit = "LiberalAlliance"; 

//Have three circles of connection strength
//Use IntDict to store weighted directional relations.
// An IntDict allows us to create pairs of "Strings" to "ints", where the strings are the key to retrieve an int value
//create Interger Dictionaries based on strength of user connections. 
// Example
// To store "User 1 was retweeted by user2 ten times, and by user3 four times, ..."
// IntDict tweeters = [("user2" -> 10), ("user3" -> 4), ...]   
IntDict weakUsers;    // 1-5 posts
IntDict mediumUsers; // 6-25 post
IntDict strongUsers; // >25 posts
//Set the number of posts between the strengths.
int weakUsersUpper = 5; 
int mediumUsersUpper = 25;


//space around the username in the display box. Used in userBox()
int boxPadding = 6;    
//flag to show the number of posts inside the box. Used in userBox()
boolean showWeight = false;
//distance from the edge of screen for the weakUser circle. Used in display()
int radiusCrop = 60;

void createLocalGraph(String userCurrent){
  String userRetweeted = "SELECT user FROM st WHERE text LIKE '%" + userCurrent 
                      + "%' ORDER BY time ASC";
  
  //This will temporary hold all the relations, so we can tally them
  IntDict retweets = new IntDict();
  
  if ( db.connect() ) {                      
    db.query(userRetweeted);

    //Tally all the results from the database into the IntDict                   
    while(db.next() ){
      //For each result in the DB, add the username of the tweeter to the IntDict
      String tweeter = db.getString("user");      
      //skip if the user is referring to themselves
      if (tweeter.equals(userCurrent)){
        continue;
      //increment a found user
      } else if (retweets.hasKey(tweeter) == true) {
        retweets.increment(tweeter);
      } else {
        //otherwise it's a new relationship, initialise the value to one
        retweets.set(tweeter,1);
      }
    }//end of db.next loop
  }//end of db.connect() block
  
  //sort all the edges in graphEdges into strength groups 
  //lets have 3 levels of strength/closeness, from weakest to strongest
  
  //we could have sorted the values ascending with
  //retweets.sortValues();
  //but it's not really needed and having the weights mixed within the strength group is prettier/more interesting
 
   //create arrays based on strength of user connections. 
   weakUsers = new IntDict();    // 1-5 posts
   mediumUsers = new IntDict(); // 6-25 post
   strongUsers = new IntDict(); // >25 posts
   
   String[] retweetUserNames = retweets.keyArray();
   for(int i = 0; i < retweetUserNames.length; i++){
     int strength = retweets.get(retweetUserNames[i]);
     
     //make new IntDicts organised by strength
     if(strength <= weakUsersUpper){
       weakUsers.set(retweetUserNames[i], strength);
     }else if(strength <= mediumUsersUpper){
       mediumUsers.set(retweetUserNames[i], strength);
     }else{ // if(strength > mediumUsersUpper)
       strongUsers.set(retweetUserNames[i], strength);
     }
   }//end for loop
  
}//end createLocalGroup


void setup() {
  db = new SQLite( this, "../data/st.db" );
  size(screen_x, screen_y);
  createLocalGraph(userInit);
}
  
void draw() {
  background(70);
  display(userInit);
}

//display the userCurrent in the center. 
//maximum radius would be the height of the screen minus textHeight
//find the big circle around the weak users and divide the arcs from there  

void display(String userCurrent){  
  //50 pix padding from the screen edge.
  float longRadius = height/2 - radiusCrop;

  //draw each user circle. We want stronger users closer to the center
  displayUsers(weakUsers, longRadius);
  displayUsers(mediumUsers, longRadius*0.6);
  displayUsers(strongUsers, longRadius*0.3);
  
  //draw the center user last (to cover the lines)
  //give it a strong weight
  userBoxCurrent(userCurrent);
}

void displayUsers(IntDict users, float radius){
  //initalise the angle
  float angle = 0;
  //divide the circle by the number of users
  float slice = 360 / (float) users.size();
  //find the co-ordinate of each user around the circle using some trigonometry
  for(String userKey : users.keys()){  
    float user_x = width/2 + cos(radians(angle))*(radius);
    float user_y = height/2 + sin(radians(angle))*(radius);
    angle = angle + slice;   
    userBox(user_x, user_y, userKey, users.get(userKey));
  }
}


//userBox handles each user box and draws the name, box and connecting line to the center
void userBox(float x, float y, String userName, int weight){
    
  textSize(12);
  float userNameHeight = textAscent() + textDescent();
  float userNameWidth = textWidth(userName);
  
  //check the upperlimit on weight, since outside the mapping range will give use other interesting values
  //what we want is the upper limit for our opacity values below
  int weightUpper = 30;
  int displayWeight;
  if (weight > weightUpper){
    displayWeight = weightUpper;
  }else{
    displayWeight = weight;
  }
  
  //draw (weighted) line to center of screen
  stroke(255, map(displayWeight, 0, weightUpper, 0, 255));
  line(x, y, width/2, height/2);
  
  
  //draw box
  //fill(255); //set rect to white  
  float fillMapped = map(displayWeight, 0, weightUpper, 0, 255); 
  //we use the opacity of box to show the strength of relation. It works well as giving a slight 3d effect too... 
  fill(255, fillMapped);
  //center rectangle 
  rectMode(CENTER);
  rect(x, y, userNameWidth+ 2*boxPadding, userNameHeight+ 2*boxPadding);
 
  //draw username  
  //fill(100);
  //we set the mapping range a bit height, so even the weak users can still be readable, but will still have an effect.
  float nameMapped = map(displayWeight, 0, weightUpper, 150 , 255);
  fill(0,nameMapped);
  textAlign(CENTER, CENTER);

  //show the actual numerical weight of the connection close to the box
  if(showWeight){
    text(userName, x, y-boxPadding);
    text(weight, x, y+boxPadding);
  }else{
    text(userName, x, y);
  }
}


//similar to userBox but only for the center/current user
void userBoxCurrent(String userCurrent){
  textSize(12);
  float userNameHeight = textAscent() + textDescent();
  float userNameWidth = textWidth(userCurrent);
  
  fill(255);
  rectMode(CENTER);
  //center rectangle 
  rect(width/2, height/2, userNameWidth+ 2*boxPadding, userNameHeight+ 2*boxPadding);
  
  fill(0);
  textAlign(CENTER, CENTER);
  text(userCurrent, width/2, height/2);
}


//possible todo: create a mousePressed() event that runs createLocalGraph(userNameClicked)
