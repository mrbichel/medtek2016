class Tweet {
  String tweet;
  String url;
  color col;
  float x,y,speedx,speedy;
  Tweet(String text, String urlx){
      tweet = text;
      url=urlx;
      insertImage(url);
      x = 0.5*width+random(max(width,tweets.size()*width/3));
      y = yBorder+random(height-yBorder);
      speedx = random(1,3);
      speedy = random(-0.3,0.3);
      col = color(random(360),80,99);
  }
  void display() {
    fill(col);
    text(tweet, x, y);
    int i = imgIndex.get(url);
    image(img[i],x-50,y-30);
  }
  void move() {
    x-=speedx;
    if (y<=yBorder || y>=height) speedy=speedy*(-1);
    y+=speedy;
  }
}

