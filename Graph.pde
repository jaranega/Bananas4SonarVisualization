class Graph {
  float values[];
  int x, y, w, h;
  color c;
  
  
  Graph(int x, int y, int w, int h, color c, int l) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.c = c;
    this.values = new float[l];
  }
  
  void addPoints(float[] points) {
    for(int i = points.length; i < this.values.length; ++i) {
      this.values[i - points.length] = this.values[i];
    }
    for(int i = this.values.length - points.length; i < this.values.length; i++) {
      this.values[i] = points[i - (this.values.length - points.length)];
    }
  }
  
  void draw() {
    float minimum = min(this.values) - 10;
    float maximum = max(this.values) + 10;
    for(int i=0; i < this.values.length - 1; i++) {
      int x1 = round(this.x + float(i)/this.values.length * this.w);
      int y1 = round(this.y + this.h * (this.values[i] - minimum) / (maximum - minimum));
      int x2 = round(this.x + float(i+1)/this.values.length * this.w);
      int y2 = round(this.y + this.h * (this.values[i+1] - minimum) / (maximum - minimum));
      
      strokeWeight(2);
      stroke(this.c);
      line(x1, y1, x2, y2);
      strokeWeight(1);
    }
  }
}