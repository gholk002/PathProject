

int[][] maze = {/*
 0 1 2 3 4 5 6 7 8 9 10 11 cols*/
{0,0,0,0,0,0,0,0,0,0,0,0}, //0 rows
{0,1,1,1,1,1,1,1,1,0,1,0}, //1
{0,1,0,0,1,0,0,1,0,0,1,0}, //2
{0,1,1,1,1,1,1,1,0,0,1,0}, //3
{0,0,0,1,0,0,0,1,1,1,1,0}, //4
{0,1,1,1,1,1,1,1,0,0,0,0}, //5
{0,1,0,1,0,1,1,1,1,1,1,0}, //6
{0,1,0,1,0,0,0,0,1,0,0,0}, //7
{0,1,0,1,1,1,0,1,1,0,0,0}, //8
{0,1,1,1,0,1,1,1,1,1,0,0}, //9
{0,1,0,1,0,1,0,0,0,1,1,0}, //10
{0,0,0,0,0,0,0,0,0,0,0,0}  //11
};
//10x10 maze with borders making it 12x12 array
Vec2 pos; //object position
Vec2 vel; //object velocity
Cell[][] nodePos = new Cell[12][12]; //null will indicate wall, .v is possible node, .i and .j are array index

ArrayList<Cell> path;
Cell startPos;
Cell goalPos;
int gridcell;
Camera camera;


ArrayList<Cell> makePath(Cell start, Cell goal, Cell[][] node){
  ArrayList<Cell> aStar = new ArrayList();
  aStar.add(start);
  println("Generating path:");
  float[][] heuristic = new float[12][12]; //generating heuristics for each node, -1 if wall
  for(int i = 0; i < 12; i++){
    for(int j = 0; j < 12; j++){
      if(node[i][j] == null){
        heuristic[i][j] = -1;
      }
      else{
        float shortestDistX = abs(goal.v.x - node[i][j].v.x);
        float shortestDistY = abs(goal.v.y - node[i][j].v.y);
        heuristic[i][j] = shortestDistX + shortestDistY;
      }
    }
  }
  int i = start.i; //casting truncates decimal
  int j = start.j;
  while(aStar.get(aStar.size()-1).v.distanceTo(goal.v) > 5){ //loops until last element in list is goal
    float smallH = Integer.MAX_VALUE; //finds node with smallest heuristic
    
    Cell nextNode = new Cell();
    if(node[i][j+1] != null && heuristic[i][j+1] < smallH){ //checks right node
      nextNode = node[i][j+1];
      smallH = heuristic[i][j+1];
    }
    if(node[i+1][j] != null && heuristic[i+1][j] < smallH){ //checks lower node
      nextNode = node[i+1][j];
      smallH = heuristic[i+1][j];
    }
    if(node[i][j-1] != null && heuristic[i][j-1] < smallH){ //checks left node
      nextNode = node[i][j-1];
      smallH = heuristic[i][j-1];
    }
    if(node[i-1][j] != null && heuristic[i-1][j] < smallH){ //checks upper node
      nextNode = node[i-1][j];
      smallH = heuristic[i-1][j];
    }
    /*else{ //surrounded by null nodes case
      println("No path possible");
      return aStar;
    }*/
    println(aStar);
    if(aStar.size() > 1 && nextNode.v.distanceTo(aStar.get(aStar.size()-2).v) == 0){ //backtracking
      node[i][j] = null; //set current "dead end" node to null
      aStar.remove(aStar.size()-1); //remove current node from list
      i = aStar.get(aStar.size()-1).i; //get coordinates of previous node
      j = aStar.get(aStar.size()-1).j;
      continue;
    }
    aStar.add(nextNode);
    i = nextNode.i; 
    j = nextNode.j;
  }
  println("\nHeuristic from starting node: "+ heuristic[start.i][start.j]);
  return aStar;
}

void setup(){
  size(1000, 1000, P3D);
  frameRate(30);
  background(75);
  fill(0,0,0);
  noStroke();
  //background(255);
  //lights();
  //fill(0);
  //strokeWeight(0);
  surface.setTitle("Pathing");
  camera = new Camera();
  for(int i = 0; i<12; i++){
    for(int j = 0; j<12; j++){
      nodePos[i][j] = new Cell(-1,-1,new Vec2(0,0));
    }
  }
  int gridcell = height/12; //length of each cell
  pos = new Vec2(gridcell*1.5, gridcell*1.5); //starting position at cell (1,1)
  vel = new Vec2(1, 0);
  startPos = new Cell((int)pos.y/gridcell, (int)pos.x/gridcell, pos.copy());
  
  goalPos = new Cell(10, 10, new Vec2(gridcell*10.5, gridcell*10.5)); //goal position at cell (10,10)
  for(int i = 0; i< 12; i++){
    for(int j = 0; j<12; j++){
      if(maze[i][j] == 0){ //draw walls
        nodePos[i][j] = null; //not traversable area

        //pushMatrix();
        //translate(j*gridcell,i*gridcell);
        //square(0,0, gridcell);
        //popMatrix();
      }
      else{
        nodePos[i][j].v = new Vec2((j+0.5)*gridcell,(i+0.5)*gridcell); //node at center of each cell
        nodePos[i][j].i = i;
        nodePos[i][j].j = j;
        //circle(nodePos[i][j].x, nodePos[i][j].y, 10);
      }
    }
  }
  //fill(250, 10, 10);
  //strokeWeight(2);
  //circle(pos.x, pos.y, gridcell*0.9);
  path = makePath(startPos, goalPos, nodePos); //initialize path
  println("Final Path: \n" + path);
  println("\nTotal Distance: " + gridcell*(path.size()-1));
}

void draw(){
  background(75);
  lights();
  camera.Update(1.0/frameRate);
  noStroke();
  for(int i = 0; i< 12; i++){
    for(int j = 0; j<12; j++){
      if(maze[i][j] == 0){ //draw walls
        pushMatrix();
        fill(0,0,0);
        translate(j*gridcell,i*gridcell,0);
        box(gridcell);
        popMatrix();
      }
      else{
        pushMatrix();
        fill(200,200,200);
        translate(j*gridcell,i*gridcell,0);
        square(0,0,gridcell);
        popMatrix();
      }
    }
  }
  fill(250, 10, 10);
  strokeWeight(2);
  update(1/frameRate);
  pushMatrix();
  translate(pos.x, pos.y, 0.5*gridcell);
  sphere(gridcell*0.9);
  popMatrix();
  pushMatrix();
  fill(10,200,10);
  translate(goalPos.j*gridcell,goalPos.i*gridcell,0);
  square(0,0,gridcell);
  popMatrix();
}

void update(float dt){
  Vec2 dir = path.get(0).v.minus(pos);
  dir.normalize();
  vel = dir.times(4); //constant velocity in correct direction
  pos.add(vel.times(dt));

  if(path.size() > 1 && pos.distanceTo(path.get(0).v) < 5){ //if arrived at node
    path.remove(0);
    startPos = new Cell((int)pos.y/gridcell, (int)pos.x/gridcell, pos.copy());
  }
}

void mousePressed(){ // new goal, new path
    Vec2 goal = new Vec2(mouseX, mouseY);
    int i = (int)(goal.y/gridcell);
    int j = (int)(goal.x/gridcell);
    goalPos = new Cell(i, j, goal);
    path = makePath(startPos, goalPos, nodePos);
}
void keyPressed()
{
  camera.HandleKeyPressed();
}

void keyReleased()
{
  camera.HandleKeyReleased();
}
