public class Cell{
  
  public int i, j;
  public Vec2 v;
  
  public Cell(){
    i = -1;
    j = -1;
    v = new Vec2(0,0);
  }
  public Cell(int indexI, int indexJ, Vec2 vec){
    i = indexI;
    j = indexJ;
    v = vec;
  }
  public String toString(){
    return "("+i + ", " + j+ ")";
  }
}
