
ArrayList<PVector> mainPoints;

ArrayList<PVector> curvePoints;
float div = 100;

int p;
boolean found = false;

boolean lines = false;
boolean points = false;
boolean addDiv = false;
boolean subDiv = false;

void setup(){
  fullScreen();
  
  //Set Up Main Points
  mainPoints = new ArrayList<PVector>();
  mainPoints.add(new PVector(width/2,height/2));

  curvePoints = new ArrayList<PVector>();
  
}

void draw(){
  background(0);
  
  //Draw Main Points
  stroke(255);
  strokeWeight(30);
  if (found){
    mainPoints.get(p).x = mouseX;
    mainPoints.get(p).y = mouseY;
  }
  for (PVector p : mainPoints) point(p.x,p.y);
  curvePoints.clear();
  strokeWeight(5);
  if (mainPoints.size() > 2){
    for (int t = 0; t < div; t++){
      curvePoints.add(recursive(mainPoints,float(t)/div));
    }
    colorMode(RGB);
    stroke(255);
    strokeWeight(10);
    for (int i = 0; i < curvePoints.size()-1; i++){
      line(curvePoints.get(i).x,curvePoints.get(i).y,curvePoints.get(i+1).x,curvePoints.get(i+1).y);
    }
    line(curvePoints.get(curvePoints.size()-1).x,curvePoints.get(curvePoints.size()-1).y,mainPoints.get(mainPoints.size()-1).x,mainPoints.get(mainPoints.size()-1).y);
  } else if (mainPoints.size() == 2) {
    stroke(255);
    strokeWeight(10);
    line(mainPoints.get(0).x,mainPoints.get(0).y,mainPoints.get(1).x,mainPoints.get(1).y);
  }
  
  UI();
}

PVector recursive(ArrayList<PVector> list, float t){
  colorMode(HSB);
  strokeWeight(3);
  if (list.size() == 3){
    float x1 = lerp(list.get(0).x,list.get(1).x,t);
    float x2 = lerp(list.get(1).x,list.get(2).x,t);
    float y1 = lerp(list.get(0).y,list.get(1).y,t);
    float y2 = lerp(list.get(1).y,list.get(2).y,t);
    float x = lerp(x1,x2,t);
    float y = lerp(y1,y2,t);   
    stroke(255,255,255,10);
    
    if (points) {
      stroke(255,255,255,100);
      point(x,y);
    }
    if (lines) { 
      stroke(255,255,255,10);
      line(x1,y1,x2,y2);
    }
    return new PVector(x,y);
  } else {
    ArrayList<PVector> first = new ArrayList<PVector>();
    ArrayList<PVector> second = new ArrayList<PVector>();
    first.addAll(list);
    first.remove(first.get(first.size()-1));
    second.addAll(list);
    second.remove(0);
    PVector v1 = recursive(first,t);
    PVector v2 = recursive(second,t);
    float x = lerp(v1.x, v2.x, t);
    float y = lerp(v1.y, v2.y, t);
    if (points) {
      stroke(map(first.size(),2,mainPoints.size(),0,255),255,255,100);
      point(x,y);
    }
    if (lines) { 
      stroke(map(first.size(),2,mainPoints.size(),0,255),255,255,10);
      line(v1.x,v1.y,v2.x,v2.y);
    }
    return new PVector(x,y);
  }
}

void UI(){
  stroke(100);
  strokeWeight(10);
  fill(150);
  rect(0,height-50,190,50);
  fill(0);
  
  textSize(40);
  textAlign(LEFT);
  text(round(div),100,height-10);
  
  textSize(20);
  text("Segment",10,height-28);
  text("Number",10,height-10);
  textSize(40);
  text(":",83,height-15);
  
  stroke(100);
  fill(150);
  rect(0,0,200,230);
  fill(0);
  
  textSize(40);
  textAlign(LEFT);
  text("Controls:",10,40);
  
  textSize(20);
  text("Right Click:",10,65);
  textSize(15);
  text("New Control Point",15,80);
  
  textSize(20);
  text("Click and Hold Points:",10,100);
  textSize(15);
  text("Move Main Points Around",15,115);
  
  textSize(20);
  text("Up and Down Arrows:",10,135);
  textSize(15);
  text("Change Segment Number",15,150);
  
  textSize(20);
  text("O Key:",10,170);
  textSize(15);
  text("Turn On or Off Lines",15,185);
  
  textSize(20);
  text("P Key:",10,205);
  textSize(15);
  text("Turn On or Off Points",15,220);
  
  if (addDiv) div *= 1.01;
  if (subDiv) div /= 1.01;
  if (div < 1) div = 1;
}

//PVector quadratic(PVector p0, PVector p1, PVector p2, float t){
//  float x1 = lerp(p0.x,p1.x,t);
//  float x2 = lerp(p1.x,p2.x,t);
//  float y1 = lerp(p0.y,p1.y,t);
//  float y2 = lerp(p1.y,p2.y,t);
//  float x = lerp(x1,x2,t);
//  float y = lerp(y1,y2,t);
//  stroke(0,0,255);
//  point(x,y);
//  //line(x1, y1, x2, y2);
//  return new PVector(x,y);
//}

//PVector cubic(PVector p0, PVector p1, PVector p2, PVector p3, float t){
//  PVector v1 = quadratic(p0, p1, p2, t);
//  PVector v2 = quadratic(p1, p2, p3, t);
//  float x = lerp(v1.x, v2.x, t);
//  float y = lerp(v1.y, v2.y, t);
//  stroke(0,255,0);
//  point(x,y);
//  //line(v1.x, v1.y, v2.x, v2.y);
//  return new PVector(x, y);
//}

void mousePressed(){
  //Move Main Points
  for (int i = 0; i < mainPoints.size(); i++){
    if (dist(mouseX,mouseY,mainPoints.get(i).x,mainPoints.get(i).y)<15){
      found = true;
      p = i;
    }
  }
  
  //Add New Main Points
  if (mouseButton == RIGHT){
    mainPoints.add(new PVector(mouseX, mouseY));
  }
}

void mouseReleased(){
  found = false;
}

void keyPressed(){
  if (key == 'p') points = !points;
  if (key == 'o') lines = !lines;
  if (keyCode == UP) addDiv = true;
  if (keyCode == DOWN) subDiv = true;
}

void keyReleased(){
  if (keyCode == UP) addDiv = false;
  if (keyCode == DOWN) subDiv = false;
}
