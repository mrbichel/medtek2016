import twitter4j.conf.*;
import twitter4j.*;
import twitter4j.auth.*;
import twitter4j.api.*;
import java.util.*;

Twitter twitter;
String searchString = "venstreorienteret";
List<Status> tweets;

int currentTweet;

void setup()
{
 size(800, 600);

 ConfigurationBuilder cb = new ConfigurationBuilder();
 cb.setOAuthConsumerKey("lVD25kDaYLhIUE504qPrPSAJe");
 cb.setOAuthConsumerSecret("37k64wJ3aG7ZztDaetmkXZonve3FB8k1PjJH5GBHmRbU6sp0Ao");
 cb.setOAuthAccessToken("3881791456-IoU5lA9rzM0F8407k05XtGBzO1QHtCXjp6zW7O1");
 cb.setOAuthAccessTokenSecret("NUKiGrhIBWbATmQHUBgVXtSwfVimKu4EKjfulOXYGV6FI");

 TwitterFactory tf = new TwitterFactory(cb.build());

 twitter = tf.getInstance();

 getNewTweets();

 currentTweet = 0;
 background(0);
 println(tweets.size());

 thread("refreshTweets");
}

void draw()
{
 //fill(0, 40);
 //rect(0, 0, width, height);
 //print(frameCount+" ");

 PImage b=get();
 background(0);
 set(-1, 0, b);


 if (frameCount%60==0) {
   currentTweet = currentTweet + 1;

   if (currentTweet >= tweets.size())
   {
     currentTweet = 0;
   }

   Status status = tweets.get(currentTweet);
   PImage profileImage=loadImage(status.getUser().getProfileImageURL());

   fill(200);
   float y = random(height);
   text(status.getText(), width-300, y, 300, 200);
   image(profileImage,width-profileImage.width-300,y);

   MediaEntity[] media = status.getMediaEntities(); //get the media entities from the status
   for(MediaEntity m : media){ //search trough your entities
     PImage image=loadImage(m.getMediaURL());
     image(image,width-image.width,height-image.height,0.5*image.width,0.5*image.height);
     System.out.println(m.getMediaURL()); //get your url!
   }

   //  delay(250);
 }
}

void refreshTweets()
{
 while (true)
 {
   getNewTweets();

   //println();
   //println();
   //println("Updated Tweets");
   //println();
   //println();

   delay(10000);
 }
}

void getNewTweets()
{
 try
 {
   Query query = new Query(searchString);

   QueryResult result = twitter.search(query);

   tweets = result.getTweets();
//    println(tweets.size());
 }
 catch (TwitterException te)
 {
   System.out.println("Failed to search tweets: " + te.getMessage());
   System.exit(-1);
 }
}
