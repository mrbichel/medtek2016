import de.bezier.data.sql.*;
SQLite db;
String[] sttext;
color[] col;
float[] x,y,speedx,speedy;
int uge = 3;
String parti = "DF";
String overskrift;
int lastKeyFrame=-10;
int yBorder=70;

void setup() {
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
  for (int i=0; i<sttext.length; i++) {
    fill(col[i]);
    text(sttext[i], x[i], y[i]);
    x[i]-=speedx[i];
    if (y[i]<=yBorder || y[i]>=height) speedy[i]=speedy[i]*(-1);
    y[i]+=speedy[i];
  }
}

void reload(int uge, String parti){
  sttext =  new String[0];
  col = new color[0];
  speedx = new float[0];
  speedy = new float[0];
  x = new float[0];
  y = new float[0];
  overskrift = parti+" på twitter i uge "+(uge+20);
  if ( db.connect() )
  {
    String Q = "select text, image from st where parti='"+parti+"' and weekno="+uge;
    db.query(Q);
    println(Q);
    while (db.next ())
    {
      sttext = append(sttext, db.getString("text"));
      x = append(x, 0.5*width+random(max(width,sttext.length*width/3)));
      y = append(y, yBorder+random(height-yBorder));
      speedx = append(speedx, random(1,3));
      speedy = append(speedy, random(-0.3,0.3));
      col = append(col, color(random(360),80,99));
    }
    println(sttext.length);
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
