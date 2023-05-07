class Snake {
  SnakePart[] snakeBody;         //Serpente
  char moveState;               //Direzione serpente
  char[] moveBuffer = {'-'};             //Contiene yutte le decisioni di svolta
  int bodyParts=4, appleEat;
  ; //Lunghezza serpente
  int w_Square=10, h_Square=10, squareRad=0;  //Largehezza-altezza quadratini
  int speed=w_Square;                       //Velocità
  color testa=color(0), standard=color(234, 104, 109);
  ;      //Colore testa e resto del corpo
  color[] ColorSequence = {color(253, 70, 70), color(88, 228, 183), color(233, 233, 86)};     //Sequenza colori bonus
  int posLastSequ;                  //Posizione dell'elemento di snakeBody[] da cui
  //partire ad effettuare il controllo della sequenza di colori
  int state=0, input=1, output=0;
  PImage tick;
  boolean changeDirect;

  public Snake() {//Costruttore - movimento di partenza,lunghezza
    tick = loadImage("./img/tick.png");
  }


  void startSet(int startX, int startY, boolean gameSnake, int dim) {//il resto del corpo è costruito a partire dalla testa verso sx
    int i;
    moveState ='-';
    changeDirect=false;
    appleEat=0;
    posLastSequ=0;
    bodyParts=dim;
    snakeBody = new SnakePart[bodyParts];
    //println(snakeBody.length);
    for (i=0; i<snakeBody.length; i++)
      snakeBody[i] = new SnakePart();
    for (i=0; i<snakeBody.length; i++) {
      snakeBody[i].posX = startX - (w_Square*i);
      snakeBody[i].posY = startY;
      if (gameSnake)snakeBody[i].c = standard;
      else snakeBody[i].c = ColorSequence[(int)random(0, snake.ColorSequence.length)];
      if (i==0)snakeBody[i].c = testa;//Colore testa
    }
  }
  void snakeAnimation() {
    if (moveState!='-') {
      changeDirect=true;
      for (int i=snakeBody.length-1; i>0; i--) {//Parte dalla "coda" e arriva fino alla parte  prima della testa
        snakeBody[i].posX = snakeBody[i-1].posX;
        snakeBody[i].posY = snakeBody[i-1].posY;
      }
      switch(moveState) {//Movimento "testa serpente".
      case 'u'://UP
        snakeBody[0].posY=snakeBody[0].posY-speed;
        break;
      case 'r'://RIGHT
        snakeBody[0].posX=snakeBody[0].posX+speed;
        break;
      case 'd'://DOWN
        snakeBody[0].posY=snakeBody[0].posY+speed;
        break;
      case 'l'://LEFT
        snakeBody[0].posX=snakeBody[0].posX-speed;
        break;
      }
      //Toro
      if (snakeBody[0].posX > xFinishField)snakeBody[0].posX=xStartField;
      if (snakeBody[0].posX < xStartField)snakeBody[0].posX=xFinishField;

      if (snakeBody[0].posY > yFinishField)snakeBody[0].posY=yStartField;
      if (snakeBody[0].posY < yStartField)snakeBody[0].posY=yFinishField;
      changeDirect=false;
    }
  }
  void randAnimation() {
    char[] move = {'u', 'r', 'd', 'l'};
    char newMove;
    newMove = move[(int)random(0, move.length)];
    switch(newMove) {//Cambio direzione.
    case 'u':
      if (moveState!='d')moveState='u';
      break;
    case 'r':
      if (moveState!='l')moveState='r';
      break;
    case 'd':
      if (moveState!='u')moveState='d';
      break;
    case 'l':
      if (moveState!='r')moveState='l';
      break;
    }
    for (int i=snakeBody.length-1; i>0; i--) {//Parte dalla "coda" e arriva fino alla parte  prima della testa
      snakeBody[i].posX = snakeBody[i-1].posX;
      snakeBody[i].posY = snakeBody[i-1].posY;
    }
    switch(moveState) {//Movimento "testa serpente".
    case 'u'://UP
      snakeBody[0].posY=snakeBody[0].posY-speed;
      break;
    case 'r'://RIGHT
      snakeBody[0].posX=snakeBody[0].posX+speed;
      break;
    case 'd'://DOWN
      snakeBody[0].posY=snakeBody[0].posY+speed;
      break;
    case 'l'://LEFT
      snakeBody[0].posX=snakeBody[0].posX-speed;
      break;
    }
    //Toro
    if (snakeBody[0].posX > xFinishField)snakeBody[0].posX=xStartField;
    if (snakeBody[0].posX < xStartField)snakeBody[0].posX=xFinishField;

    if (snakeBody[0].posY > yFinishField)snakeBody[0].posY=yStartField;
    if (snakeBody[0].posY < yStartField)snakeBody[0].posY=yFinishField;
  }
  void drawSnake() {
    int i;
    for (i=0; i<snakeBody.length; i++) {
      fill(snakeBody[i].c);
      rect(snakeBody[i].posX, snakeBody[i].posY, w_Square, h_Square, squareRad);
      fill(255);
    }
  }
  void changeMoveState(int tastoPrem) {
    char newMove;
    switch(tastoPrem) {//Nuova svolta richiesta.
    case UP:
      moveBuffer = append(moveBuffer, 'u');
      break;
    case RIGHT:
      moveBuffer = append(moveBuffer, 'r');
      break;
    case DOWN:
      moveBuffer = append(moveBuffer, 'd');
      break;
    case LEFT:
      moveBuffer = append(moveBuffer, 'l');
      break;
    }
    if (play==true && moveBuffer.length>0 && changeDirect==false) {
      changeDirect=true;
      newMove = moveBuffer[moveBuffer.length-1];////Prelievo prima svolta richiesta
      moveBuffer = shorten(moveBuffer);
      println(moveBuffer);
      switch(newMove) {//Nuova svolta richiesta.
      case 'u':
        if (moveState!='d')moveState='u';
        break;
      case 'r':
        if (moveState!='l')moveState='r';
        break;
      case 'd':
        if (moveState!='u')moveState='d';
        break;
      case 'l':
        if (moveState!='r')moveState='l';
        break;
      }
    }
  }
  void colorSequenceControl() {
    state=0;
    input=1;
    output=0;
    int[][] ts = {{1, 0, 0}, {1, 2, 0}, {1, 0, 0}};//Tabella transizione degli stati
    int[][] tu = {{0, 0, 0}, {0, 0, 0}, {0, 0, 1}};//Tabella transizione uscite
    for (int i=posLastSequ+1; i<snakeBody.length && snakeBody[i].c!=standard; i++) {
      if (snakeBody[i].c==ColorSequence[0])input=0;
      if (snakeBody[i].c==ColorSequence[1])input=1;
      if (snakeBody[i].c==ColorSequence[2])input=2;
      output = tu[state][input];//output
      state = ts[state][input];//New state;
      if (output==1) {//sequenza trovata
        bigPoint.pause();
        bigPoint.rewind();
        bigPoint.play();
        points+=100;
        posLastSequ=i;
        println("Sequenza completata!!");
        break;
      }
    }
    //println("");
    //println("state: "+state);
    //println("input: "+input);
    //println("output: "+output);
  }
  void drawColorProgres() {
    fill(ColorSequence[0]);
    rect(170, 12, 13, 13);
    if (state>0)image(tick, 170, 12);
    fill(ColorSequence[1]);
    rect(190, 12, 13, 13);
    if (state>1)image(tick, 190, 12);
    fill(ColorSequence[2]);
    rect(210, 12, 13, 13);
    fill(255);
  }
  boolean selfCollision() {
    int i;
    for (i=2; i<snake.snakeBody.length; i++) {//Collisione su se stesso
      if (snake.snakeBody[0].posX==snake.snakeBody[i].posX && snake.snakeBody[0].posY==snake.snakeBody[i].posY) {
        play=false;
        menu.menuState='f';
        return true;
      }
    }
    return false;
  }
  boolean enviromentCollision() {
    int i;
    for (i=0; i<labirints[labChoise].ostacoli.length; i++) {//Collisione con il labirinto
      if ( (snake.snakeBody[0].posX>=labirints[labChoise].ostacoli[i].posX && snake.snakeBody[0].posX<labirints[labChoise].ostacoli[i].posX+labirints[labChoise].ostacoli[i].w) && (snake.snakeBody[0].posY>=labirints[labChoise].ostacoli[i].posY && snake.snakeBody[0].posY<labirints[labChoise].ostacoli[i].posY+labirints[labChoise].ostacoli[i].h) ) {
        play=false;
        menu.menuState='f';//Fine del gioco
        return true;
      }
    }
    return false;
  }
}
