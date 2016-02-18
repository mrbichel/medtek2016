// Eksempel 2 - Konverter tidspunkter i java
// I dette ekesempel ser vi på hvordan vi kan arbejde med de datoer og tidspunkter der ligger i databasen

import de.bezier.data.sql.*;
SQLite db;

// vi skal bruge de to følgende java klasser til at bearbejde tid og dato
import java.text.SimpleDateFormat;
import java.util.Date;


void setup() {
  db = new SQLite( this, "../data/st.db" );

  if ( db.connect() ) {

    String Q = "select time, text from st";

    db.query(Q);

    while (db.next ()) {

      String tweet = db.getString("text");

      int time = db.getInt("time");

      // Tidspunktet er et unix timestamp
      // Det er en simpel måde at regne tid på hvor alle tidspunkter
      // er defineret som det antal sekunder der er gået siden 1. Jan 1970 (UTC) 
      // man bruger ofte unix timestamp til at repræsenterer tidspunkter når man programmerer
      // da det er meget simplere at bruge et enkelt tal til fx. at sortere en database efter dato
      // end det er at bruge vores system i år, måneder, dage, timer, minutter og sekunder hvor ingen af 
      // delelementerne går op i 10 

      // java bruger unix timestamps der defineret ned til millissekunder og ikke kun sekunder
      // du skal derfor gange tidspunktet med 1000
      Date date = new Date((long)time*1000);
      
      // brug SimpleDateFormat klassen til at definerer hvordan dato og tid skal formateres
      // se oversigt her over de forskellige bogstaver du kan bruge: 
      // http://docs.oracle.com/javase/7/docs/api/java/text/SimpleDateFormat.html
      
      String newDateString = new SimpleDateFormat("d. MMM HH:mm").format(date); // 9:00
      
      // Lad os forkorte tweetet lidt så det er nemmere at overskue datoerne
      tweet = tweet.substring(0, Math.min(tweet.length(), 20)) + "...";
      
      println(newDateString + ": " + tweet);

      // Øvelse:
      // 1. Formater datoen med navnet på hvilken ugedag 

    }
    exit();
  }
}



