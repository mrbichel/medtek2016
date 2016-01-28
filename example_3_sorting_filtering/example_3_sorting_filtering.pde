// Eksempel 2 - sortering og filtrering med sql
// I dette ekesempel ser vi hvordan vi med SQL kan sortere og filtrere data

import de.bezier.data.sql.*;
SQLite db;

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

    }
  }
}



