import de.bezier.data.sql.*;
SQLite db;

ArrayList<Word> words;

int maxn=-1;
int minn=9999;
int uge = 1;
String parti = "DF";
String overskrift;
int lastKeyFrame=-100;
int yBorder=70;
String[] wi = {"stwi","stw2i","stw3i"};
int wii = 2;
int wiLimit = 1;

void setup() {
  words = new ArrayList<Word>();
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
  int synligt = 0;
  for (int i=0; i<words.size(); i++) {
    words.get(i).display();
    synligt+=max(0,words.get(i).x);
    words.get(i).move();
  }
  if (synligt==0 && uge<33){
    uge++;
    reload(uge,parti);
  }
}

void reload(int uge,String parti){
  words.clear();
  maxn=-1;
  minn=9999;
  overskrift = parti+" på twitter i uge "+(uge+20);
  if ( db.connect() )
  {
    String Q = "select word, count(*) n from st, "+wi[wii]+" where st.id="+wi[wii]+".id and parti='"+parti+"' and weekno="+uge+" group by word having n>"+wiLimit+" order by n desc";
    db.query(Q);
    println(Q);
    while (db.next ())
    {
      Word word = new Word(db.getString("word"),db.getInt("n"));
      words.add(word);
    }
    if(minn==maxn) maxn++;
    println(words.size());
    fill(0, 0, 200);
    for (int i=0; i<words.size(); i++) {
      words.get(i).tS = map(words.get(i).n,minn,maxn,16,40);
      words.get(i).speedx = random(0.4*map(words.get(i).n,minn,maxn,4,2),0.7*map(words.get(i).n,minn,maxn,4,2));
    }
  }
}

void keyPressed(){
  if (key=='1' || key == '2' || key == '3' || key == '4' || key == '5' || key == '6' || key == '7' || key == '8' || key == '9' || key == '0') {
    if (frameCount-lastKeyFrame<10 && uge<6) 
      uge = uge*10+key-48; 
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
    case 'q': if (wii>0) wii--;
    break;
    case 'w': if (wii<2) wii++;
    break;
    case 'z': if (wiLimit>0) wiLimit--;
    break;
    case 'x': if (wiLimit<4) wiLimit++;
    break;
  }
  lastKeyFrame=frameCount;
//  uge=uge+1;
  reload(uge,parti);  
}
