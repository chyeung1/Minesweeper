import de.bezier.guido.*;
public int NUM_ROWS = 10; //20;
public int NUM_COLS = 8; //24;
public int NUM_MINES = 10; //99;
public String difficulty = "easy";
public int totalClear = 0;
public int totalFlagged = 0;
public float time = 0;
public boolean firstClick = true;
public boolean pleaseWork = false;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(500, 500);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    //your code to initialize buttons goes here
    createButtons();
}
public void createButtons(){
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
    background(17, 35, 128);
    if(isWon()){
        displayWinningMessage();
        noLoop();
    }
    if(!pleaseWork && !firstClick)
    time += frameRate/3600;
    fill(0);
    textSize(20);
    //timer
    text("timer: " + (int)time, 50, 450);
    //flags
    text("flags: " + (NUM_MINES - totalFlagged), 150, 450);
    //reset button and difficult button
    fill(120);
    rect(400, 435, 80, 30);
    rect(270, 435, 120, 30);
    fill(0);
    textSize(30);
    text(difficulty, 330, 450);
    text("reset", 440, 450);
}

public void reset(int r, int c){
  time = 0;
  totalFlagged = 0;
  totalClear = 0;
  firstClick = true;
  pleaseWork = false;
  for(int i = 0; i < r; i++){
    for(int j = 0; j < c; j++){
        buttons[i][j].clicked = false;
        buttons[i][j].flagged = false;
        buttons[i][j].setLabel("");
        mines.clear();
      }
    }
    loop();
}
public boolean isWon()
{
    //your code here
    return totalClear == NUM_ROWS * NUM_COLS - NUM_MINES;
}
public void displayLosingMessage()
{
    //your code here
    for(int i = 0; i < NUM_ROWS; i++)
      for(int j = 0; j < NUM_COLS; j++)
        if(mines.contains(buttons[i][j])) {
          buttons[i][j].clicked = true;
        } else if(buttons[i][j].flagged) {
         buttons[i][j].flagged = false;
         buttons[i][j].setLabel("L"); 
        } else 
         buttons[i][j].setLabel("L"); 
   pleaseWork = true;
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
//ui control stuff
public void mousePressed(){
  if(mouseX >= 400 && mouseX <= 480 && mouseY >= 435 && mouseY <= 465)
  reset(NUM_ROWS, NUM_COLS);
  if(mouseX >= 270 && mouseX <= 390 && mouseY >= 435 && mouseY <= 465){
 /* if(difficulty.equals("easy")){
    difficulty = "medium";
    NUM_MINES = 40;
    NUM_ROWS = 14;
    NUM_COLS = 18;
    reset(10, 8);
    createButtons();
  }
  else if(difficulty.equals("medium")){
    difficulty = "hard";
    NUM_MINES = 99;
    NUM_ROWS = 20;
    NUM_COLS = 24;
    reset(14, 18);
    createButtons();
  }
  else{
      difficulty = "easy";
      NUM_MINES = 10;
      NUM_ROWS = 10;
      NUM_COLS = 8;
      reset(20, 24);
      createButtons();
    }*/
  }
}
//actually useful minesweeper stuff
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 432/NUM_COLS;
        height = 420/NUM_ROWS;
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
      if(!flagged && !(myLabel.equals("L") || myLabel.equals("W")) && !mines.contains(this) && !clicked && !(mouseButton == RIGHT)) {
        if(firstClick){
          setMines(myRow, myCol);
          firstClick = false;
        }
      clicked = true;
      totalClear++;
      }
       if(mouseButton == RIGHT && !clicked && !(myLabel.equals("L") || myLabel.equals("W"))){
        flagged = !flagged;
        if(!flagged){
        clicked = false;
        totalFlagged-- ;
        setLabel("");
        } else if(flagged)
        totalFlagged++;
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
        textSize(10);
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
