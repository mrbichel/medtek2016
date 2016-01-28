import de.bezier.data.sql.*;
SQLite db;
String[] word = {};
int[] n = {};
color[] col = {};
float[] speedx = {};
float[] speedy = {};
float[] x = {};
float[] y = {};
float[] tS = {};
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
  size( 800, 600 );
  colorMode(HSB);
  db = new SQLite( this, "..data/st.db" );  // open database file
  reload(uge,parti);
}
void draw() {
  background(200);
  fill(#151DE5);
  textSize(48);
  text(overskrift,200,50);
  int synligt = 0;
  for (int i=0; i<word.length; i++) {
    textSize(tS[i]);
    fill(col[i]);
    synligt+=max(0,x[i]);
    text(word[i], x[i], y[i]);
    x[i]-=speedx[i];

    if (y[i]<yBorder || y[i]>=height) speedy[i]=speedy[i]*(-1);
    y[i]+=speedy[i];
  }
  if (synligt==0 && uge<33){
    uge++;
    reload(uge,parti);
  }
}

void reload(int uge,String parti){
  word =  new String[0];
  n = new int[0];
  maxn=-1;
  minn=9999;
  col = new color[0];
  speedx = new float[0];
  speedy = new float[0];
  x = new float[0];
  y = new float[0];
  tS = new float[0];

  overskrift = parti+" på twitter i uge "+(uge+20);
  if ( db.connect() )
  {
    String Q = "select word, count(*) n from st, "+wi[wii]+" where st.id="+wi[wii]+".id and parti='"+parti+"' and weekno="+uge+" group by word having n>"+wiLimit+" order by n desc";
    db.query(Q);
    println(Q);
    while (db.next ())
    {
      word = append(word, db.getString("word"));
      n = append(n, db.getInt("n"));
      maxn=max(maxn, db.getInt("n"));
      minn=min(minn, db.getInt("n"));
    }
    if(minn==maxn) maxn++;
    println(word.length);
    fill(0, 0, 200);
    for (int i=0; i<word.length; i++) {
      tS = append(tS, map(n[i],minn,maxn,16,40));
      x = append(x, 0.5*width+random(max(width,word.length*width/30)));
      float nyy = yBorder+int(random(height-yBorder));
      y = append(y, nyy);
      speedx = append(speedx, random(0.4*map(n[i],minn,maxn,4,2),0.7*map(n[i],minn,maxn,4,2)));
      float nyspeedy=random(-0.3,0.3);
//      float nyspeedy=random(0.3);
//      if (nyy>0.55*height) nyspeedy=nyspeedy*(-1);
      speedy = append(speedy, nyspeedy);
      col = append(col, color(random(360),80,99));
    }
//      println(minn,maxn);
//      printArray(speedx);
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
