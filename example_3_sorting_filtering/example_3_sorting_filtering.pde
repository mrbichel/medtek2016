// Eksempel 3 - sortering og filtrering med sql
// I dette ekesempel ser vi hvordan vi med SQL kan sortere og filtrere data
// Vi ser også på hvordan vi kan begynde at visualisere vores data

import de.bezier.data.sql.*;
SQLite db;

// lad os laveet array af text som vi kan gemme twets i og vise dem på skærmen
// vi gemmer vores tweets sp vi ikke skal hente dem fra databasen hver eneste frame vi vil tegne dem
// det tager relativt lang tid at hente data ud af databasen, men når vi først har det i vores lokale 
// hukommelse for vores program går det lynhurtigt
String[] tweetStrings;

// Vi opretter 2 variabler vi bruger til at lave en simpel scroll feature med musen
float offsetX, offsetY;

void setup() {
  // Vi skal initialiserer vores array før vi kan bruge det
  tweetStrings = new String[0];
  
  // size definerer vores vindues størrelse
  size( 800, 600 );
  
  db = new SQLite( this, "../data/st.db" );

  if ( db.connect() ) {
    
    // I SQL bruger vi keywordet where til at definerer en filtrering af vores data
    // med keywordet order by kan vi sortere resultaterne efter et felt
    // med keywordet limit begrænser vi hvor resultater vi maximalt vil have returneret
    
    // Her finder vi de første 100 tweets sorteret alfabetisk som er postet af politkere i Liberal Alliance 
    
    String parti = "LA";
    String Q = "select time, text from st where parti='"+parti+"'"+" order by text limit 100" ;

    db.query(Q);
    
    while (db.next ()) {
      String tweet = db.getString("text");
      
      // vi tilføjer hvert resultat fra vores query til vores array af tweets
      tweetStrings = append(tweetStrings, tweet);
    }
  }
}

// I draw ligger kode der bliver kørt hver eneste fram vi tegner til skærmen
// Gerne 30 gange i sekundet eller mere, men hvis vi skriver kode der er meget tungt kan det komme til at køre langsommere 
void draw() {
  
  // lad os gå igennem all de tweets vi har hentet fra databasen og tegne dem i en lang liste på skærmen
  background(0); // sort baggrund
  fill(255);     // hvid tekst
  textSize(24);  // størrelse på tekst 
  
  // Scroll op og ned i top og bund af skærm og venstre højre i side når musetast holdes nede
  if (mousePressed == true) {
    if(mouseX > width*0.75 && mouseX < width) offsetX-=2;
    if(mouseX < width*0.25 && mouseX > 0) offsetX+=2;
    if(mouseY > height*0.75 && mouseY < height) offsetY-=2;
    if(mouseY < height*0.25 && mouseY > 0) offsetY+=2;
  }
  
  for(int i=0; i<tweetStrings.length; i++) {
    text(tweetStrings[i], 20 +offsetX , offsetY + 20 + i * 30);
  }
  
  
  
}

// Øvelser
// 1. sorter tweets efter hvilke politikere der har skrevet dem
// 2. 




