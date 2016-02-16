import de.bezier.data.sql.*;
SQLite db;

import wordcram.*;
import wordcram.text.*;

WordCram wordCram;

ArrayList<Word> vizWords;

void initWordCram() {

  Word[] simpleArray = new Word[ vizWords.size() ];
  vizWords.toArray( simpleArray );

  wordCram = new WordCram(this)
      .fromWords(simpleArray)
      //.withFont(createFont("../../LiberationSerif-Regular.ttf", 1))
      .sizedByWeight(10, 90)
      .withColors(color(0, 250, 200), color(30), color(170, 230, 200));
}


void setup() {

  vizWords = new ArrayList<Word>();

  size(800, 600);
  colorMode(HSB);
  
  // Vi skal initialiserer vores array før vi kan bruge det
  //tweetStrings = new String[0];
  
  db = new SQLite( this, "../data/st.db" );

  //allWords = new String[0];

  if ( db.connect() ) {
    
    // I SQL bruger vi keywordet where til at definerer en filtrering af vores data
    // med keywordet order by kan vi sortere resultaterne efter et felt
    // med keywordet limit begrænser vi hvor resultater vi maximalt vil have returneret
    
    // Her finder vi de første 100 tweets sorteret alfabetisk som er postet af politkere i Liberal Alliance 
    
    String Q = "select time, text, parti from st order by time limit 1000" ;

    db.query(Q);
    
    // regular expressions and lists 

    // tag alle biord ud

    // hastags 

    // farvelæg ord baseret på hvilke partier der bruger dem mest
    // farvelæg baseret på tid i valgkamp, 1 farve pr uge fx. 

    // lav wordcloud med n-gram 2 i stedet

    // split sætninger før ngams, undgå ngrams på tværs af sætninger 

    // undgå lister af hastags

    // hirstoriefortælling - baseret på temaord 

    String[] ignoreWords = {"#dkpol", "RT", "#fv15", "#FT15", "#tv2valg", "#DRdinstemme", "om", "vil", "man", "får", "nok", "var", "som", "har", "de", "vi", "nu", "Det", "der", "sig", "Så", "så", "hos", "at", "i", "I", "den", "det", "er", "og", "en", "med", "på", "til", "også", "for", "af", "ikke"};

    while (db.next ()) {
      String tweet = db.getString("text");
      String parti = db.getString("parti");

      // fjern links - regex fra http til mellemrum
      tweet = tweet.replaceAll("https?://\\S+\\s?", "");

      //String[] newWords = splitTokens(tweet, ",.!? \"'():");
      String[] newWords = split(tweet, " ");

	  for(int i=0; i<newWords.length-2; i++) {

	  	String w = newWords[i] + " " + newWords[i+1] + " " + newWords[i+2]; // ngram-3

	  	// go through an ignore list of words we dont want, use regex instead
	  	/*boolean ignore = false;
	  	for(int gi=0; gi<ignoreWords.length; gi++) {
	  		if (ignoreWords[gi].equals(newWords[i])) {
	  			ignore = true;
	  		}
	  	}*/

	  	//if(!ignore) {
		  	boolean wordFound = false;
		  	for(int wi=0; wi<vizWords.size(); wi++) {
		  		if (vizWords.get(wi).word.equals(w)) {
		  			vizWords.get(wi).weight += 0.15;
		  			wordFound = true;
		  		}
		  	}
		  	if(!wordFound) {
		  		vizWords.add(new Word(w, 0.0));
		  	}
	  	//}

	  }

	  // exclude retweets probably 


    }


    initWordCram();


  }
}

// I draw ligger kode der bliver kørt hver eneste fram vi tegner til skærmen
// Gerne 30 gange i sekundet eller mere, men hvis vi skriver kode der er meget tungt kan det komme til at køre langsommere 
void draw() {
  
  // lad os gå igennem all de tweets vi har hentet fra databasen og tegne dem i en lang liste på skærmen
  //background(0); // sort baggrund
  fill(255);     // hvid tekst
  textSize(24);  // størrelse på tekst
  
  /*for(int i=0; i<tweetStrings.length; i++) {
    text(tweetStrings[i], 20 +offsetX , offsetY + 20 + i * 30);
  }*/

  if (wordCram.hasMore()) {
    wordCram.drawNext();
  }
  
}






