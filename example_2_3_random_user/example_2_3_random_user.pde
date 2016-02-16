// Example 2.3 Display random User 
// 
// Query the DB to find the "unique" values of a given table value, using the "Group by" condition
// We use it here to find the names of all the users in the database.
// Useful for finding IDs any sort of data in a table that is stamped with an ID.

//Load library
import de.bezier.data.sql.*;

//Initiaise and maybe set the global variables
SQLite db;
int screen_x = 400;
int screen_y = 300;
int textsize = 30;
String queryAllUsers = "SELECT user FROM st GROUP BY user";
String[] allUsers = new String[0];
String userCurrent;

void queryForAllUsers(){
  //query the database and put all the usernames into allUsers array; 
  if ( db.connect() ) {
    db.query(queryAllUsers);
  }
  while (db.next()){
    String userName = db.getString("user");
    allUsers = append(allUsers, userName);
  }
}

void setup(){
  size(screen_x,screen_y);
  db = new SQLite( this, "../data/st.db" );
  queryForAllUsers();
  randomUser();
  println(userCurrent);     
}

void draw(){  
  background(0);
  textSize(textsize);
  textAlign(CENTER,CENTER);
  text(userCurrent, width/2, height/2);
}

void keyPressed() {
  randomUser();
}

//now we're being a bit tricky here. Because we know we'll probably want to later
//use this "get a random user name from the twitter db" code for later, we create this 
//function returning a String. In this sketch, we're using the "userCurrent" global variable
//but in other code/programs, we might want to be "passing around" the variable.
//This modularity helps keep code re-useable.
String randomUser(){
  
  int index = int(random(allUsers.length));
  
  userCurrent = allUsers[index];
  return userCurrent;
}


