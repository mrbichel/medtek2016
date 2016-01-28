// Eksempel 1 - Forbind til sqlite database
// I dette ekesempel opretter vi forbindelse til databasen og 
// laver et enkelt simpelt dataudtræk med alle tweets

// Vi bruger tabellen st der har følgende kolonner

    // parti
    // text
    // user
    // id
    // image
    // created_at
    // time
    // dayno
    // weekno
    
// En tabel i en database er lidt som et regneark med rækker og kollonnner
// Hver kolonne definerer en type data vi lagrer og hver række indeholder den specifikke data
// I dette tilfælde er hver række et tweet og forskellige metadata om det tweet

// Her importerer vi BEzierSQL, det er et library vi bruger til
// at forbinde og søge data i databasen
// BEzierSQL skal du ligge i mappen libraries 
import de.bezier.data.sql.*;

// BEzierSQL har en klasse der hedder SQLite, den bruger vi til at interface med vores 
// SQLite database
SQLite db;


import java.text.SimpleDateFormat;
import java.util.Date;

// I setup funktionen ligger kode der bliver kørt én gang når programmet starter
void setup() {
  
  // Opret database klassen, sørg for at st.db den ligger på den rigtige sti
   db = new SQLite( this, "../data/st.db" );
   
  // forbind til databasen
  if ( db.connect() ) {
    
    // Her skrive vi vores SQL forespørgsel
    // Vælg alt fra tabellen st
    // Stjernealias (*) bruges som en genvej til at vælge alle felter i en tabel
    String Q = "select * from st";
    
    // String Q = "select * from st";
    // er det samme som at skrive
    // String Q = "select parti, text, user, id, image, created_at, time, dayno, weekno from st";
      
    // Udfør forespørgslen, vores query
    db.query(Q);
    
    // Løb resultaterne igennem et af gangen
     while (db.next ()) {
       
       // funktionen db.next() flytter en markør et felt 
       // frem i resultatet af den query vi har foretaget
       // når der ikke er flere resultater returnere den false 
       
       // nu kan vi tilgå de forskellige felter i st tabellens kolonner 
       // med følgende funktioner
       // String number = db.getString([KOLONNENS_NAVN]) 
         // Bruges til at tilgå tekstfelter
       
       // int tal = db.getInt([KOLONNENS_NAVN]) 
         // Bruges til at tilgå tal felter
         
       // I vores tabel har vi kun de to typer data, tekst og heltal
       // I processing bruger vi datatypen String til tekst og int til heltal
       // i vores database hedder typerne  varchar og integer
               
       // Gem twitter beskedens indhold i en variabel
       String tweet = db.getString("text");
       
       // Gem tidspunkt twitter beskeden er lagt ud
       
       int time = db.getInt("time");
       
       // Tidspunktet er et unix timestamp
       // Det er en simpel måde at regne tid på hvor alle tidspunkter
       // er defineret som det antal sekunder der er gået siden 1. Jan 1970 (UTC) 
       // man bruger ofte unix timestamp til at repræsenterer tidspunkter når man programmere
       // da det er meget simplere at bruge et enkelt tal til fx. at sortere en database efter dato
       // end det er at bruge vores system i år, måneder, dage, timer, minutter og sekunder hvor ingen af 
       // delelementerne går op i 10 
       
       // Lad os skrive ud for hvert tweet indholdet af beskeden og hvornår det er postet 
       // println skriver tekst til panelet nederst i processing vinduet
       println("Tidspunkt: " + time + ", Tweet: " + tweet );
         
                // Øvelser:
       
       // 1. prøv at skrive ud hvem der har skrevet twitter beskeden, ligger i kolonnen user
       
       // 2. prøv at skrive tidspunkterne i et andet format, år, måned, dag, time, minut fx.
       // hint, søg på 
       Date pdate = new Date();
       pdate = new SimpleDateFormat("ddMMMyy:HH:mm").parse(time);
       
       println(pdate);
         
        
     }
     
     exit();
  }
}


       // Yderligere læsning:
