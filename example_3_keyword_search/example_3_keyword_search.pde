// Eksempel 4 - LIKE - søgemaskine
// I dette ekesempel ser vi hvordan vi med SQL kan sortere på mønstre i data

import de.bezier.data.sql.*;
SQLite db;

// I dette eksempel har vi brug for lidt flere informationer om hvert tweet når vi tegner det
// så vi samler det i en klasse
class Tweet {
  String tweet;
  String[] words;
}

String lastsearchword;
String selectedWord;

ArrayList<Tweet> tweets;

// Vi flytter vores query til en funktion, så vi kan kalde den dynamisk når programmet kører
void searchWord(String _keyword) {
  
   lastsearchword = _keyword;
   
    // I SQL bruger vi operatoren LIKE til at finde resultater der matcher et bestemt mønster
    // Det kan fx være et eller flere ord der indgår i et tweet 
    // eller vi kan finde alle brugere der starter med et bestemt bogstav
    
    // Lad os bygge en lille søgemaskine til at finde tweets der har ord tilfælles
    
    // Når man bruger like operatoren kan man indsætte % (procenttegn) eller _ (underscore) til 
    // at definerer et mønster. 
    // % matcher en hvilken som helst sekvens af ingen eller flere karakterer i en streng.
    // _ matcher en hvilken som helst enkelt karakter, i enten upper eller lower case 
    // hver opmærksom på at sqlite kun forstår upper lower case sammenhæng for ASCII karakterer 
    // det betyder at fx. æøå ikke matcher ÆØÅ
    
    String Q = "select text from st where text like '%" + _keyword + "%' order by text limit 50" ;

    db.query(Q);
    
    tweets.clear();
    
    while (db.next ()) {
      
      String tweetString = db.getString("text").toLowerCase();
      
      tweetString = tweetString.replace('\n', ' ');
      tweetString = tweetString.replace("larsloekke", "larsloekke den lille svindler");
      tweetString = tweetString.replace("løkke", "løkke den lille svindler");

      Tweet tweet = new Tweet();
      // split the tweet into words
      tweet.tweet = tweetString;
      tweet.words = splitTokens(tweetString, ",.!? \"'()");
      
      tweets.add(tweet);
      
      println(tweet.words);     
    }
}

void setup() {
  tweets = new ArrayList<Tweet>();
  size( 1600, 1000 );
  db = new SQLite( this, "../data/st.db" );
  
  if ( db.connect() ) {
    searchWord("stole ");
  } 
}

void draw() {
  background(0);

  float lineHeight = 30;
  float yOffset = 30;
  
  selectedWord = "";
  
  for(int i=0; i<tweets.size(); i++) {
 
    float centerKeywordX = -textWidth(split(tweets.get(i).tweet, lastsearchword)[0]) + width/2 - textWidth(lastsearchword)/2;
    
    fill(255,255,255,190);
    textSize(24);
    
    text(tweets.get(i).tweet, centerKeywordX, yOffset);
    
    for(int wi=0; wi<tweets.get(i).words.length; wi++) {
      
      String w = tweets.get(i).words[wi];
      float wordWidth = textWidth(w);
      
      String[] beforeAfter = split(tweets.get(i).tweet, w);
      float xOffset = centerKeywordX + textWidth(beforeAfter[0]); // Denne linje virker ikke korrekt hvis ordet forekomemr mere end 1. gang i et tweet
      
      // Highlight the word the mouse is over
      if(mouseX > xOffset-2 &&
         mouseX < xOffset+wordWidth+2 && 
         mouseY > yOffset-(lineHeight*0.85) && 
         mouseY < yOffset+(lineHeight*0.1) ) {
        
          selectedWord = w;
          fill(255,0,0);
          text(w, xOffset, yOffset);
      }         
    }
    
    yOffset += lineHeight;
  }
}

void mousePressed() {
  if(selectedWord != "") {
    searchWord(selectedWord);
  }  
}

// Øvelser
// 1.  
// 2. Ændre programmet så det søger på en kombination af flere ord
