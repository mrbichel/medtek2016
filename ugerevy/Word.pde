class Word {
  String word;
  int n;
  color col;
  float x,y,speedx,speedy,tS;
  Word(String wordx, int nx){
      word = wordx;
      n=nx;
      maxn=max(maxn, n);
      minn=min(minn, n);
      x = 0.5*width+random(max(width,words.size()*width/30));
      y = yBorder+int(random(height-yBorder));
      speedy=random(-0.3,0.3);
      col = color(random(360),80,99);
  }
  void display() {
    textSize(tS);
    fill(col);
    text(word, x, y);
  }
  void move() {
    x-=speedx;
    if (y<yBorder || y>=height) speedy=speedy*(-1);
    y+=speedy;
  }
}

