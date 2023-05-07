//SNAKE - Andrea Del Coro - Gabriele giovannelli
//Librerie aggiuntive per gestione suonisnake.squareRad
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;
//import gifAnimation.*;

int points;
int startFrame=0;               //Contatore frame x movimento a scatti
Snake snake;                    //Serpente di gioco
Snake fakeSnake1;                //Serpente di simulazione uno
Snake fakeSnake2;                //Serpente di simulazione due
Snake fakeSnake3;                //Serpente di simulazione tre
Snake fakeSnake4;                //Serpente di simulazione quattro
Snake fakeSnake5;                //Serpente di simulazione cinque
Apple[] apples;                 //Mele
Labirint[] labirints;            //Labirinti
Menu menu;
Table table;
String diffColum;
int labChoise;                   //Scelta labirinto
int difficult;                   //Scelta difficoltà

boolean play;

int xStartField, xFinishField;
int yStartField, yFinishField;
int w_field, h_field;

PFont font;
PImage sfondo;

Minim minim, minim2, minim3, minim4, minim5, minim6, minim7;
AudioPlayer point, bigPoint, click, conferma, menuSong, playSong, over;
//Gif rec;
void setup() {
  size(400, 400);
  frameRate(60);
  points=0;

  xStartField=20;
  xFinishField=370;
  yStartField=30;
  yFinishField=370;
  w_field=360;
  h_field=350;
  labChoise=0;
  difficult=5;

  snake = new Snake();
  //snake.startSet(40,200,true,10);//param. --> startX,startY
  apples = new Apple[2];
  applesStartSet();
  setLabirints();

  play=false;
  font = createFont("./font/ALBA____.TTF", 20);
  sfondo = loadImage("./img/field.gif");

  minim = new Minim(this);
  point = minim.loadFile("./sounds/takeApple.mp3");
  minim2 = new Minim(this);
  bigPoint = minim2.loadFile("./sounds/cash.mp3");

  minim3 = new Minim(this);
  click = minim3.loadFile("./sounds/click.mp3");
  click.rewind();
  minim4 = new Minim(this);
  conferma = minim4.loadFile("./sounds/conferma.mp3");
  minim5 = new Minim(this);
  menuSong = minim5.loadFile("./sounds/menuMusicShort.mp3");
  menuSong.loop();
  minim6 = new Minim(this);
  playSong = minim6.loadFile("./sounds/gameMusic.mp3");
  minim7 = new Minim(this);
  over = minim7.loadFile("./sounds/gameOver.wav");
  //rec = new Gif(this,"./img/new.gif");
  menu = new Menu();
  menu.updateMenu();
  updateRecords();
  textFont(font);
  strokeWeight(1.3);
}

void draw() {
  background(sfondo);
  userInterface();
  if (play) {//Stai giocando
    labirints[labChoise].drawLabirint();
    if (frameCount==startFrame+difficult) {//Il serp. si muove ogni 3 Frame.
      startFrame=frameCount;
      snake.snakeAnimation();
    }
    snake.drawSnake();//Disegna il serpente
    setApples();//Calcola le cordinate delle mele
    drawApples();//Disegna le mele
    snake.enviromentCollision();//Gestisce le collisioni con l'ambiente
    snake.selfCollision();//Gestisce le collisioni con se stesso
    aplleCollision();//Gestisce le collisioni con le mele
    snake.colorSequenceControl();//Controlla se è stata raggiuna la sequenzadi colori bonus.
    snake.drawColorProgres();//Indica il colre raggiunto nella sequenza.
  }
}
Boolean updateRecords() {
  diffColum = new String();
  table = loadTable("Record.csv", "header");//Carico tabella
  switch(difficult) {
  case 2:
    diffColum="Dif";
    break;
  case 5:
    diffColum="Norm";
    break;
  case 8:
    diffColum="Faci";
    break;
  }
  if (points > table.getInt(labChoise, diffColum)) {//Record Labirinto battuto.
    table.setInt(labChoise, diffColum, points);
    saveTable(table, "Record.csv");
    return true;
  }
  return false;
}
void userInterface() {
  menu.updateMenu();//Aggiorna il menu allo rispetto allo stato in cui si trova.
  menu.drawOption();
}
void mousePressed() {
  menu.selectOption(mouseX, mouseY);//Cambia le stato del menu
  menu.labChoise(mouseX, mouseY);//Definisce il valore della variabile "labChoise";
  menu.musicOnOff(mouseX, mouseY);
}
void applesStartSet() {
  int i;
  apples = new Apple[2];
  for (i=0; i<apples.length; i++) {
    apples[i] = new Apple();
    apples[i].eat=true;
    if (i==0)apples[i].c=snake.ColorSequence[0];
    else apples[i].c=snake.ColorSequence[1];
  }
}
void setLabirints() {
  Ostacolo newOstacolo;
  labirints = new Labirint[9];   //numero labirinti
  labirints[0] = new Labirint(4);//Labirinto 1
  labirints[1] = new Labirint(10);//Labirinto 2
  labirints[2] = new Labirint(4);//Labirinto 3
  labirints[3] = new Labirint(8);//Labirinto 4
  labirints[4] = new Labirint(11);//Labirinto 5
  labirints[5] = new Labirint(2);//Labirinto 6
  labirints[6] = new Labirint(3);//Labirinto 7
  labirints[7] = new Labirint(9);//Labirinto 8
  labirints[8] = new Labirint(18);//Labirinto 8
  //------------------->Labirinto 1<-------------------
  newOstacolo = new Ostacolo(xStartField, yStartField, xFinishField-xStartField, snake.h_Square, color(174, 113, 22));
  labirints[0].ostacoli[0]=newOstacolo;
  newOstacolo = new Ostacolo(xStartField, yStartField, snake.w_Square, yFinishField-yStartField, color(174, 113, 22));
  labirints[0].ostacoli[1]=newOstacolo;
  newOstacolo = new Ostacolo(xStartField, yFinishField, xFinishField-xStartField+snake.w_Square, snake.h_Square, color(174, 113, 22));
  labirints[0].ostacoli[2]=newOstacolo;
  newOstacolo = new Ostacolo(xFinishField, yStartField, snake.w_Square, yFinishField-yStartField, color(174, 113, 22));
  labirints[0].ostacoli[3]=newOstacolo;
  //------------------->Labirinto 2<-------------------
  newOstacolo = new Ostacolo(xStartField, yStartField, 50, snake.h_Square, color(174, 113, 22));
  labirints[1].ostacoli[0]=newOstacolo;
  newOstacolo = new Ostacolo(xStartField, yStartField, snake.w_Square, 50, color(174, 113, 22));
  labirints[1].ostacoli[1]=newOstacolo;
  newOstacolo = new Ostacolo(xStartField, yFinishField-50, snake.w_Square, 50, color(174, 113, 22));
  labirints[1].ostacoli[2]=newOstacolo;
  newOstacolo = new Ostacolo(xStartField, yFinishField, 50, snake.h_Square, color(174, 113, 22));
  labirints[1].ostacoli[3]=newOstacolo;
  newOstacolo = new Ostacolo(xFinishField-50, yFinishField, 50, snake.h_Square, color(174, 113, 22));
  labirints[1].ostacoli[4]=newOstacolo;
  newOstacolo = new Ostacolo(xFinishField, yFinishField-50, snake.w_Square, 60, color(174, 113, 22));
  labirints[1].ostacoli[5]=newOstacolo;
  newOstacolo = new Ostacolo(xFinishField, yStartField, snake.w_Square, 50, color(174, 113, 22));
  labirints[1].ostacoli[6]=newOstacolo;
  newOstacolo = new Ostacolo(xFinishField-50, yStartField, 50, snake.h_Square, color(174, 113, 22));
  labirints[1].ostacoli[7]=newOstacolo;
  newOstacolo = new Ostacolo(170, 180, 70, snake.h_Square, color(174, 113, 22));
  labirints[1].ostacoli[8]=newOstacolo;
  newOstacolo = new Ostacolo(170, 200, 70, snake.h_Square, color(174, 113, 22));
  labirints[1].ostacoli[9]=newOstacolo;
  //------------------->Labirinto 3<-------------------
  newOstacolo = new Ostacolo(xStartField+140, yStartField+40, snake.w_Square, 100, color(174, 113, 22));
  labirints[2].ostacoli[0]=newOstacolo;
  newOstacolo = new Ostacolo(xStartField+200, yStartField+130, 100, snake.h_Square, color(174, 113, 22));
  labirints[2].ostacoli[1]=newOstacolo;
  newOstacolo = new Ostacolo(xStartField+50, yStartField+180, 100, snake.h_Square, color(174, 113, 22));
  labirints[2].ostacoli[2]=newOstacolo;
  newOstacolo = new Ostacolo(xStartField+200, yStartField+180, snake.w_Square, 100, color(174, 113, 22));
  labirints[2].ostacoli[3]=newOstacolo;
  //------------------->Labirinto 4<-------------------
  newOstacolo = new Ostacolo(xStartField, yStartField, w_field, snake.h_Square, color(174, 113, 22));
  labirints[3].ostacoli[0]=newOstacolo;
  newOstacolo = new Ostacolo(xStartField, yStartField, snake.w_Square, 150, color(174, 113, 22));
  labirints[3].ostacoli[1]=newOstacolo;
  newOstacolo = new Ostacolo(xFinishField, yStartField, snake.w_Square, 150, color(174, 113, 22));
  labirints[3].ostacoli[2]=newOstacolo;
  newOstacolo =new Ostacolo(xStartField, yFinishField-140, snake.w_Square, 150, color(174, 113, 22));
  labirints[3].ostacoli[3]=newOstacolo;
  newOstacolo = new Ostacolo(xStartField, yFinishField, w_field, snake.h_Square, color(174, 113, 22));
  labirints[3].ostacoli[4]=newOstacolo;
  newOstacolo = new Ostacolo(xFinishField, yFinishField-140, snake.w_Square, 150, color(174, 113, 22));
  labirints[3].ostacoli[5]=newOstacolo;
  newOstacolo = new Ostacolo(xStartField+100, yStartField+100, snake.w_Square, 150, color(174, 113, 22));
  labirints[3].ostacoli[6]=newOstacolo;
  newOstacolo = new Ostacolo(xStartField+260, yStartField+100, snake.w_Square, 150, color(174, 113, 22));
  labirints[3].ostacoli[7]=newOstacolo;
  //------------------->Labirinto 5<-------------------
  newOstacolo = new Ostacolo(xStartField, yStartField, 100, snake.h_Square, color(174, 113, 22));
  labirints[4].ostacoli[0]=newOstacolo;
  newOstacolo = new Ostacolo(xStartField+150, yStartField, 170, snake.h_Square, color(174, 113, 22));
  labirints[4].ostacoli[1]=newOstacolo;
  newOstacolo = new Ostacolo(xStartField, yStartField, snake.w_Square, 100, color(174, 113, 22));
  labirints[4].ostacoli[2]=newOstacolo;
  newOstacolo = new Ostacolo(xStartField, yStartField+130, 220, snake.h_Square, color(174, 113, 22));
  labirints[4].ostacoli[3]=newOstacolo;
  newOstacolo = new Ostacolo(xFinishField-90, yStartField+130, 100, snake.h_Square, color(174, 113, 22));
  labirints[4].ostacoli[4]=newOstacolo;
  newOstacolo = new Ostacolo(xStartField+150, yStartField, snake.w_Square, 130, color(174, 113, 22));
  labirints[4].ostacoli[5]=newOstacolo;
  newOstacolo = new Ostacolo(xStartField+50, yFinishField-100, 50, snake.h_Square, color(174, 113, 22));
  labirints[4].ostacoli[6]=newOstacolo;
  newOstacolo = new Ostacolo(xStartField+150, yFinishField-100, 50, snake.h_Square, color(174, 113, 22));
  labirints[4].ostacoli[7]=newOstacolo;
  newOstacolo = new Ostacolo(xStartField+250, yFinishField-100, 50, snake.h_Square, color(174, 113, 22));
  labirints[4].ostacoli[8]=newOstacolo;
  newOstacolo = new Ostacolo(xStartField+110, yFinishField-50, 20, 20, color(174, 113, 22));
  labirints[4].ostacoli[9]=newOstacolo;
  newOstacolo = new Ostacolo(xStartField+220, yFinishField-50, 20, 20, color(174, 113, 22));
  labirints[4].ostacoli[10]=newOstacolo;
  //------------------->Labirinto 6<-------------------
  newOstacolo = new Ostacolo(190, yStartField, snake.w_Square, h_field, color(174, 113, 22));
  labirints[5].ostacoli[0]=newOstacolo;
  newOstacolo = new Ostacolo(xStartField, 190, w_field, snake.h_Square, color(174, 113, 22));
  labirints[5].ostacoli[1]=newOstacolo;
  //------------------->Labirinto 7<-------------------
  newOstacolo = new Ostacolo(xStartField, h_field-100, w_field, snake.h_Square, color(174, 113, 22));
  labirints[6].ostacoli[0]=newOstacolo;
  newOstacolo = new Ostacolo(120, h_field-100, snake.w_Square, 130, color(174, 113, 22));
  labirints[6].ostacoli[1]=newOstacolo;
  newOstacolo = new Ostacolo(w_field-100, h_field-100, snake.w_Square, 130, color(174, 113, 22));
  labirints[6].ostacoli[2]=newOstacolo;
  //------------------->Labirinto 8<-------------------
  newOstacolo = new Ostacolo(xStartField+30, yStartField+30, snake.w_Square, 100, color(174, 113, 22));
  labirints[7].ostacoli[0]=newOstacolo;
  newOstacolo = new Ostacolo(xStartField+30, yStartField+230, snake.w_Square, 90, color(174, 113, 22));
  labirints[7].ostacoli[1]=newOstacolo;
  newOstacolo = new Ostacolo(xStartField+30, yStartField+30, 290, snake.h_Square, color(174, 113, 22));
  labirints[7].ostacoli[2]=newOstacolo;
  newOstacolo = new Ostacolo(xStartField+320, yStartField+30, snake.w_Square, 100, color(174, 113, 22));
  labirints[7].ostacoli[3]=newOstacolo;
  newOstacolo = new Ostacolo(xStartField+30, yStartField+320, 290, snake.h_Square, color(174, 113, 22));
  labirints[7].ostacoli[4]=newOstacolo;
  newOstacolo = new Ostacolo(xStartField+320, yStartField+230, snake.w_Square, 100, color(174, 113, 22));
  labirints[7].ostacoli[5]=newOstacolo;
  newOstacolo = new Ostacolo(xStartField+80, yStartField+80, 100, snake.h_Square, color(174, 113, 22));
  labirints[7].ostacoli[6]=newOstacolo;
  newOstacolo = new Ostacolo(xStartField+170, yStartField+80, snake.w_Square, 200, color(174, 113, 22));
  labirints[7].ostacoli[7]=newOstacolo;
  newOstacolo = new Ostacolo(xStartField+180, yStartField+270, 100, snake.h_Square, color(174, 113, 22));
  labirints[7].ostacoli[8]=newOstacolo;
  //------------------->Labirinto 9<-------------------
  newOstacolo = new Ostacolo(xStartField+20, yStartField+10, snake.w_Square, 150, color(174, 113, 22));
  labirints[8].ostacoli[0]=newOstacolo;
  newOstacolo = new Ostacolo(xStartField+20, yStartField+190, snake.w_Square, 150, color(174, 113, 22));
  labirints[8].ostacoli[1]=newOstacolo;
  newOstacolo = new Ostacolo(xStartField+20, yStartField+10, 130, snake.h_Square, color(174, 113, 22));
  labirints[8].ostacoli[2]=newOstacolo;
  newOstacolo = new Ostacolo(xStartField+20, yStartField+330, 130, snake.h_Square, color(174, 113, 22));
  labirints[8].ostacoli[3]=newOstacolo;
  newOstacolo = new Ostacolo(xStartField+140, yStartField+10, snake.w_Square, 80, color(174, 113, 22));
  labirints[8].ostacoli[4]=newOstacolo;
  newOstacolo = new Ostacolo(xStartField+330, yStartField+10, snake.w_Square, 150, color(174, 113, 22));
  labirints[8].ostacoli[5]=newOstacolo;
  newOstacolo = new Ostacolo(xStartField+220, yStartField+10, 110, snake.h_Square, color(174, 113, 22));
  labirints[8].ostacoli[6]=newOstacolo;
  newOstacolo = new Ostacolo(xStartField+220, yStartField+10, snake.w_Square, 80, color(174, 113, 22));
  labirints[8].ostacoli[7]=newOstacolo;
  newOstacolo = new Ostacolo(xStartField+330, yStartField+190, snake.w_Square, 150, color(174, 113, 22));
  labirints[8].ostacoli[8]=newOstacolo;
  newOstacolo = new Ostacolo(xStartField+220, yStartField+330, 110, snake.h_Square, color(174, 113, 22));
  labirints[8].ostacoli[9]=newOstacolo;
  newOstacolo = new Ostacolo(xStartField+140, yStartField+250, snake.w_Square, 80, color(174, 113, 22));
  labirints[8].ostacoli[10]=newOstacolo;
  newOstacolo = new Ostacolo(xStartField+220, yStartField+250, snake.w_Square, 80, color(174, 113, 22));
  labirints[8].ostacoli[11]=newOstacolo;
  newOstacolo = new Ostacolo(xStartField+200, yStartField+90, 30, snake.h_Square, color(174, 113, 22));
  labirints[8].ostacoli[12]=newOstacolo;
  newOstacolo = new Ostacolo(xStartField+140, yStartField+90, 30, snake.h_Square, color(174, 113, 22));
  labirints[8].ostacoli[13]=newOstacolo;
  newOstacolo = new Ostacolo(xStartField+140, yStartField+250, 30, snake.h_Square, color(174, 113, 22));
  labirints[8].ostacoli[14]=newOstacolo;
  newOstacolo = new Ostacolo(xStartField+200, yStartField+250, 30, snake.h_Square, color(174, 113, 22));
  labirints[8].ostacoli[15]=newOstacolo;
  newOstacolo = new Ostacolo(xStartField+160, yStartField+150, 50, 50, color(174, 113, 22));
  labirints[8].ostacoli[16]=newOstacolo;
  newOstacolo = new Ostacolo(xStartField+280, yStartField+100, 10, 150, color(174, 113, 22));
  labirints[8].ostacoli[17]=newOstacolo;
}
void setApples() {
  int i, j;
  int stepX=-1, stepY=-1;
  boolean goodPosition;
  int n=0;
  int x=0, y=0;
  int lastStepX=0, lastStepY=0;
  for (i=0; i<apples.length; i++) {
    //Generazione mele
    if (apples[i].eat) {
      //Colore mela
      n = (int)random(0, snake.ColorSequence.length);
      apples[i].c=snake.ColorSequence[n];
      goodPosition=false;
      while (goodPosition==false) {
        goodPosition=true;
        //Evita che le due mele si sovrappongano
        /*rect(20,30,10,10);//Quad in alto a sx
         rect(20,height-30,10,10);//Quad in basso a sx
         rect(width-30,30,10,10);//Quad in alto a destra
         rect(width-30,height-30,10,10);//Quad in basso a destra  */
        stepX = (int)(random(0, w_field/snake.w_Square));
        stepY = (int)(random(0, h_field/snake.h_Square));
        while (stepX==lastStepX || stepY==lastStepY) {
          stepX = (int)(random(0, w_field/snake.w_Square));
          stepY = (int)(random(0, h_field/snake.h_Square));
        }
        x= (stepX*snake.w_Square)+xStartField;
        y= (stepY*snake.h_Square)+yStartField;
        //Controllo validità posizioni
        for (j=0; j<snake.snakeBody.length; j++) {//Evita la generazione sul serpente
          if (snake.snakeBody[j].posX==x && snake.snakeBody[j].posY==y)
            goodPosition=false;
        }
        for (j=0; j<labirints[labChoise].ostacoli.length; j++) {//Evita la generazione sul labirinto
          if ( (x>=labirints[labChoise].ostacoli[j].posX && x<labirints[labChoise].ostacoli[j].posX+labirints[labChoise].ostacoli[j].w) && (y>=labirints[labChoise].ostacoli[j].posY && y<labirints[labChoise].ostacoli[j].posY+labirints[labChoise].ostacoli[j].h) )
            goodPosition=false;
        }
      }
      lastStepX = stepX;
      lastStepY = stepY;
      apples[i].posX= x;
      apples[i].posY= y;
      apples[i].eat=false;
    }
  }
}

void drawApples() {
  for (int i=0; i<apples.length; i++) {
    fill(apples[i].c);
    rect(apples[i].posX, apples[i].posY, snake.w_Square, snake.h_Square, snake.squareRad);
    fill(255);
  }
}
void keyPressed() {
  snake.changeMoveState(keyCode);
}
void gameReload() {
  points=0;
  applesStartSet();
  //snake.bodyParts=4;   //Lunghezza iniziale del serpente
  snake.startSet(40, 200, true, 10);//param. --> startX,startY
}
void aplleCollision() {
  SnakePart newPart;
  int i;
  for (i=0; i<apples.length; i++) {
    if (snake.snakeBody[0].posX==apples[i].posX && snake.snakeBody[0].posY==apples[i].posY) {//Collisione con una mela
      point.play();
      snake.appleEat++;
      apples[i].eat=true;
      points+=7;
      snake.bodyParts++;
      newPart = new SnakePart();
      newPart.c = snake.standard;//Aumento lunghezza
      snake.snakeBody=(SnakePart[])(append(snake.snakeBody, newPart));
      snake.snakeBody[snake.appleEat].c=apples[i].c;
    }
  }
}
