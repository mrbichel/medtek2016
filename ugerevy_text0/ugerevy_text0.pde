import de.bezier.data.sql.*;
SQLite db;

ArrayList<Tweet> tweets;

int uge = 3;
String parti = "DF";
String overskrift;
int lastKeyFrame=-10;
int yBorder=70;

void setup() {
  tweets = new ArrayList<Tweet>();
  size( 800, 600 );
  colorMode(HSB);
  db = new SQLite( this, "../data/st.db" );  // open database file
  reload(uge,parti);
}

void draw() {
  background(200);
  fill(#151DE5);
  textSize(48);
  text(overskrift,200,50);
  textSize(16);
  for (int i=0; i<tweets.size(); i++) {
    tweets.get(i).display();
    tweets.get(i).move();
  }
}

void reload(int uge, String parti){
  tweets.clear();
  overskrift = parti+" på twitter i uge "+(uge+20);
  if ( db.connect() )
  {
    String Q = "select text, image from st where parti='"+parti+"' and weekno="+uge;
    db.query(Q);
    println(Q);
    while (db.next ())
    {
      Tweet tweet = new Tweet(db.getString("text"));
      tweets.add(tweet);
    }
    println(tweets.size());
  }
}

void keyPressed(){
  if (key=='1' || key == '2' || key == '3' || key == '4' || key == '5' || key == '6' || key == '7' || key == '8' || key == '9' || key == '0') {
    if (frameCount-lastKeyFrame<10 && uge<6) 
      uge = uge*10+key-48;  // to numeriske taster nedtrykket hurtigt efter hinanden
    else 
      uge=key-48;
  } 
  switch(key){
    case '+': uge++;
    break;
    case '-': uge--;
    break;
    case 'a': 
    case 's': parti="S";
    break;
    case 'b': 
    case 'r': parti="RV";
    break;
    case 'c': 
    case 'k': parti="KF";
    break;
    case 'f': parti="SF";
    break;
    case 'i': 
    case 'l': parti="LA";
    break;
    case 'o': 
    case 'd': parti="DF";
    break;
    case 'v': parti="V";
    break;
    case 'ø': 
    case 'e': parti="EL";
    break;
    case 'å': parti="ALT";
    break;
  }
  
  lastKeyFrame=frameCount;
  reload(uge,parti);  
}
