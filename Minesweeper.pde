import de.bezier.guido.*;
public final static int NUM_ROWS = 10;
public final static int NUM_COLS = 8;
public final static int NUM_MINES = 10;
public int totalClear = 0;
public boolean firstClick = true;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
   // System.out.println(countMines(1, 1));
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int i = 0; i < NUM_ROWS; i++){
      for(int j = 0; j < NUM_COLS; j++){
        buttons[i][j] = new MSButton(i, j);
      }
    }
}
public void setMines(int r, int c)
{
    //your code
    int count = 0;
    while(count < NUM_MINES) {
    int row = (int)(Math.random() * NUM_ROWS);
    int col = (int)(Math.random() * NUM_COLS);
    if(!mines.contains(buttons[row][col]) && 
       (!(row == r && col == c ) && 
       !(row == r - 1 && col == c - 1) &&
       !(row == r - 1 && col == c ) &&
       !(row == r - 1 && col == c + 1) &&
       !(row == r  && col == c - 1) &&
       !(row == r  && col == c + 1) && 
       !(row == r + 1 && col == c - 1) &&
       !(row == r + 1 && col == c ) &&
       !(row == r + 1 && col == c + 1))
       ) {
    mines.add(buttons[row][col]);
    count++;
    }
    }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true){
        displayWinningMessage();
        noLoop();
    }
}
public boolean isWon()
{
    //your code here
    if(totalClear == NUM_ROWS * NUM_COLS - NUM_MINES)
    return true;
    return false;
}
public void displayLosingMessage()
{
    //your code here
    for(int i = 0; i < NUM_ROWS; i++)
      for(int j = 0; j < NUM_COLS; j++)
        if(mines.contains(buttons[i][j])) {
          buttons[i][j].clicked = true;
        } else {
         buttons[i][j].setLabel("L"); 
        }
}
public void displayWinningMessage()
{
    //your code here
    for(int i = 0; i < NUM_ROWS; i++)
      for(int j = 0; j < NUM_COLS; j++)
        buttons[i][j].setLabel("W");
}
public boolean isValid(int r, int c)
{
    //your code here
    boolean row = r >= 0 && r < NUM_ROWS;
    boolean col = c >= 0 && c < NUM_COLS;
    return row && col;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int i = row - 1; i <= row + 1; i++){
    for(int j = col - 1; j <= col + 1; j++){
    if(isValid(i, j) && !(i == row && j == col)){
     if(mines.contains(buttons[i][j])){
     numMines++;
      }
     }
    }
   }
  return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // this is certainly one of the functions of all time
    public void mousePressed () 
    {
      if(!flagged && !(myLabel.equals("L") || myLabel.equals("W")) && !mines.contains(this) && !clicked) {
        if(firstClick){
          setMines(myRow, myCol);
          firstClick = false;
        }
      clicked = true;
      totalClear++;
      }
       if(mouseButton == RIGHT && !clicked){
        flagged = !flagged;
        if(!flagged){
        clicked = false;
        setLabel("");
        }
      } else if(!flagged && mines.contains(this)) {
      displayLosingMessage();
      } else if(countMines(myRow, myCol) > 0 && !(myLabel.equals("L") || myLabel.equals("W"))){
       setLabel(countMines(myRow, myCol));
      } else if(!flagged){
        if(isValid(myRow - 1, myCol- 1) && !buttons[myRow - 1][myCol - 1].clicked)
        buttons[myRow - 1][myCol - 1].mousePressed();
        if(isValid(myRow - 1, myCol) && !buttons[myRow - 1][myCol].clicked)
        buttons[myRow - 1][myCol].mousePressed();
        if(isValid(myRow - 1, myCol + 1) && !buttons[myRow - 1][myCol + 1].clicked)
        buttons[myRow - 1][myCol + 1].mousePressed();
        if(isValid(myRow, myCol - 1) && !buttons[myRow][myCol - 1].clicked)
        buttons[myRow][myCol - 1].mousePressed();
        if(isValid(myRow, myCol + 1) && !buttons[myRow][myCol + 1].clicked)
        buttons[myRow][myCol + 1].mousePressed();
        if(isValid(myRow + 1, myCol - 1) && !buttons[myRow + 1][myCol - 1].clicked)
        buttons[myRow + 1][myCol - 1].mousePressed();
        if(isValid(myRow + 1, myCol) && !buttons[myRow + 1][myCol].clicked)
        buttons[myRow + 1][myCol].mousePressed();
        if(isValid(myRow + 1, myCol + 1) && !buttons[myRow + 1][myCol + 1].clicked)
        buttons[myRow + 1][myCol + 1].mousePressed();
      }
    }
   
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
