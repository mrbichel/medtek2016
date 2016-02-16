// Natural join er en måde hvorpå vi kan forbinde 2 tabeller i databasen så vi kan tilgå dem som 
// om de var en, det kræver at de to tabeller har en kolonne med samme navn hvor data altid matcher
// i vores tilfælde har vi en tabel der hedder users der indholder specifikke informationer om de enkelte politikere
// det er praktisk at have i sin egen tabel da vi ellers skulle replikerer informationen for hvert eneste tweet
// det ville optage rigtig meget data, hardisk plads og være mindre effektivt at søge i
// vores users tabel har et user felt som er politikerens unikke twitter handle og vores st tabel har den samme kolonne
// der er flere kolonner i de to tabeller som jeg har udeladt i repræsentationen her 


//    [st tabel]                                                    [users tabel]
//    +---------+--------------+-------------------+                +-------------------+-----------------------+          
//    | parti   | text         | user              |  NATURAL JOIN  | user              | name                  |         
//    +---------+--------------+-------------------+                +-------------------+-----------------------+ 
//  1 | "S"     | "RT @benedi" | "rasmushorn"      |       +        | "rasmushorn"      | "Rasmus Horn Langhoff"|     
//  2 | "S"     | "Håber ikke" | "YildizAkdogan"   |       +        | "YildizAkdogan"   | "Yildiz Akdogan"      |  
//  3 | "ALT"   | "RT @uffeel" | "rasmusnordqvist" |       +        | "rasmusnordqvist" | "rasmus nordqvist"    |       
//  4 | "S"     | "@benedikte" | "JulieSkovsby"    |       +        | "JulieSkovsby"    | "Julie Skovsby"       |       
//  5 | "S"     | "RT @BosseS" | "mettereissmann"  |       +        | "mettereissmann"  | "Mette Reissmann"     |  
//  6 | "S"     | "Godt nytår" | "Antorini123"     |       +        | "Antorini123"     | "Christine Antorini"  |  
//  7 | "DF"    | "Krydser fi" | "MFjeppejakobsen" |       +        | "MFjeppejakobsen" | "Jeppe Jakobsen"      |  
//    +---------+--------------+-------------------+                +-------------------+-----------------------+


import de.bezier.data.sql.*;
SQLite db;

void setup() {
  
   db = new SQLite( this, "../data/st.db" );
   
  if ( db.connect() ) {
    
    // Vi vælger alle kolonner fra både st og users med natural join
    // Vi vælger de første 7 tweets sorteret efter tidspunkt
    String Q = "select * from st natural join users order by time DESC limit 7";      
    db.query(Q);
    
     while (db.next ()) {
               
       String tweet = db.getString("text");
       
       // Vi kan nu tilgå name fordi vi har lavet et natural join med users tabellen
       String name = db.getString("name");

       println(name + ": " + tweet);      

       // Prøv at tilgå andre felter i users tabellen, fx. url, description eller statuses_count
        
     }
     
     exit();
  }
}



