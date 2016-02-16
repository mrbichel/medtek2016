// Eksempel 1 - Forbind til sqlite database
// I dette ekesempel opretter vi forbindelse til databasen og 
// laver et enkelt simpelt dataudtræk med alle tweets

// Vi bruger tabellen st der har følgende kolonner


//    +---------+--------------+-------------------+--------------------+---------------+------------+-----------+--------+--------+
//    | parti   | text         | user              | id                 | image         | created_at | time      | dayno  | weekno |
//    +---------+--------------+-------------------+--------------------+---------------+------------+-----------+--------+--------+
//  1 | "S"     | "RT @benedi" | "rasmushorn"      | 682951506958618625 |"http://abs.tw"|Fri Jan 01  |1451663302 |229     |33      |
//  2 | "S"     | "Håber ikke" | "YildizAkdogan"   | 682947465742532612 |"http://abs.tw"|------------|-----------|--------|--------|
//  3 | "ALT"   | "RT @uffeel" | "rasmusnordqvist" | 682942258270875648 |"http://abs.tw"|------------|-----------|--------|--------|
//  4 | "S"     | "@benedikte" | "JulieSkovsby"    | 682942241829208064 |"http://abs.tw"|------------|-----------|--------|--------|
//  5 | "S"     | "RT @BosseS" | "mettereissmann"  | 682941332046921728 |"http://abs.tw"|------------|-----------|--------|--------|
//  6 | "S"     | "Godt nytår" | "Antorini123"     | 682940712426598402 |"http://abs.tw"|------------|-----------|--------|--------|
//  7 | "DF"    | "Krydser fi" | "MFjeppejakobsen" | 682933666872451072 |"http://abs.tw"|------------|-----------|--------|--------|
//    +---------+--------------+-----------+------------+---------------+---------------+------------+-----------+--------+--------|

// Ovenstående er en visuel repræsentation af hvad der svarer til følgende query "select * from st order by time limit 7" har 
// forkortet text og image og kun indsat tidspunkter for den første.

// Forkortet data for #4 ovenfor:
//     text: @benediktekiaer Er det virkelighed? Det er da et stort privilegium for kommunens småbørnsfamilier. #dkpol #kom.velfærd"  
//     image: "http://abs.twimg.com/images/themes/theme1/bg.png"  
//     created_at: "Fri Jan 01 15:11:33 +0000 2016"  


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
       
       // Lad os skrive ud for hvert tweet indholdet af beskeden og hvornår det er postet 
       // println skriver tekst til panelet nederst i processing vinduet
       println("Tidspunkt: " + time + ", Tweet: " + tweet );
       
       //______________________________________
       
       // Øvelser:
       // 1. prøv at skrive ud hvem der har skrevet twitter beskeden, ligger i kolonnen user       
        
     }
     
     exit();
  }
}



