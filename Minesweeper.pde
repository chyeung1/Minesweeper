import de.bezier.guido.*;
public final static int NUM_ROWS = 10;
public final static int NUM_COLS = 8;
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
    setMines();
}
public void setMines()
{
    //your code
    int count = 0;
    while(count < 10) {
    int row = (int)(Math.random() * NUM_ROWS);
    int col = (int)(Math.random() * NUM_COLS);
    if(!mines.contains(buttons[row][col])) {
    mines.add(buttons[row][col]);
    count++;
    }
    }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    //your code here
    
    return false;
}
public void displayLosingMessage()
{
    //your code here
    System.out.println("skill issue");
}
public void displayWinningMessage()
{
    //your code here
    System.out.println("you win I guess");
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

    // called by manager
    public void mousePressed () 
    {
      clicked = true;
      if(mouseButton == RIGHT){
        flagged = !flagged;
        if(flagged == false)
        clicked = false;
      } else if(mines.contains(this)) {
      displayLosingMessage();
      } else if(countMines(myRow, myCol) > 0){
       setLabel(countMines(myRow, myCol));
      } else {
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
