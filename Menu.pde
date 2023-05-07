class Menu {
  int xTit=90, yTit=20;
  char menuState='m';
  char lastState='-';
  VoceMenu[] voci;
  int posLeftX=5, posLeftY=180;
  int posRightX=350, posRightY=180;
  int musX=30, musY=height-60;
  PImage leftArrow, rightArrow, tabScore, tableRec, logo, x;
  PImage start, help, score, home, ok, repeat, difficile, facile, medio, labi, medal, tabPoints, on, off, music, nota;
  boolean newRecord=false;
  /*
  m -> main
   l -> scegli labirinto
   d -> difficolta
   g -> gioco
   */

  public Menu() {//Imposta menu selezione labirinto
    leftArrow = loadImage("./img/leftArrow.png");
    rightArrow = loadImage("./img/rightArrow.png");
    logo = loadImage("./img/titolo.png");
    tableRec = loadImage("./img/tabRecord.png");
    start = loadImage("./img/play.png");
    help = loadImage("./img/help.png");
    score = loadImage("./img/score.png");
    home = loadImage("./img/home.png");
    ok = loadImage("./img/ok.png");
    repeat = loadImage("./img/repeat.png");
    tabScore = loadImage("./img/tabScore.png");
    //rec.loop();
    //rec.play();
    facile = loadImage("./img/facile.png");
    medio = loadImage("./img/medio.png");
    difficile = loadImage("./img/diff.png");
    labi = loadImage("./img/lab.png");
    medal = loadImage("./img/newRecord.png");
    tabPoints = loadImage("./img/pointsTab.png");
    nota = loadImage("./img/nota.png");
    on = loadImage("./img/on.png");
    off = loadImage("./img/off.png");
    music = on;
    x = loadImage("./img/x.png");
  }
  void updateMenu() {//Cambia menu in base allo stato
    if (menuState!=lastState) {
      lastState=menuState;
      switch(menuState) {
      case 'm'://imposta menu principale
        fakeSnake1 = new Snake();
        fakeSnake1.startSet(40, 200, false, 5);//param. --> startX,startY
        fakeSnake2 = new Snake();
        fakeSnake2.startSet(100, 80, false, 8);//param. --> startX,startY
        fakeSnake3 = new Snake();
        fakeSnake3.startSet(300, 320, false, 10);//param. --> startX,startY
        fakeSnake4 = new Snake();
        fakeSnake4.startSet(300, 220, false, 5);//param. --> startX,startY
        fakeSnake5 = new Snake();
        fakeSnake5.startSet(200, 20, false, 5);//param. --> startX,startY
        if (menuSong.isPlaying()==false && music==on) menuSong.loop();
        if (playSong.isPlaying())playSong.pause();
        voci = new VoceMenu[3];
        voci[0] = new VoceMenu(165, 130, start, "", 'l');
        voci[1] = new VoceMenu(131, 190, help, "", 't');
        voci[2] = new VoceMenu(195, 190, score, "", 'r');
        startFrame = frameCount;
        break;
      case 't'://imposta schermata tutorial
        voci = new VoceMenu[1];
        voci[0] = new VoceMenu(365, 21, 10, 10, "", 'm');//Per tornare al menu principale
        break;
      case 'r'://imposta schermata record
        voci = new VoceMenu[1];
        voci[0] = new VoceMenu(365, 21, 10, 10, "", 'm');//Per tornare al menu principale
        break;
      case 'l'://imposta schermata x scelta lab
        voci = new VoceMenu[2];
        voci[0] = new VoceMenu(305, 0, home, "", 'm');//Per tornare al menu principale
        voci[1] = new VoceMenu(270, 0, ok, "", 'd');//Per confermare lab
        break;
      case 'd'://imposta schermata x scelta difficoltà
        voci = new VoceMenu[3];
        voci[0] = new VoceMenu(330, 330, home, "", 'm');//Per tornare al menu principale
        voci[1] = new VoceMenu(260, 330, labi, "", 'l');//Per tornare alla scelta lab.
        voci[2] = new VoceMenu(295, 330, ok, "", 'g');//Per confermare difficolta e iniziare a giocare
        break;
      case 'g'://imposta schermata x giocare
        menuSong.pause();
        menuSong.rewind();
        if (playSong.isPlaying()==false && music==on) {
          playSong.rewind();
          playSong.loop();
        }
        gameReload();//Ripristino
        play = true;
        startFrame = frameCount;
        break;
      case 'f'://imposta schermata x ripristinare il gioco
        if (over.isPlaying()==false) {
          over.rewind();
          over.play();
        }
        play = false;
        newRecord = updateRecords();//Aggiorna i record
        voci = new VoceMenu[2];
        voci[0] = new VoceMenu(330, 330, home, "", 'm');//Per tornare al menu principale
        voci[1] = new VoceMenu(295, 330, repeat, "", 'g');//Per tornare alla scelta lab.
        break;
      }
    }
  }
  void drawOption() {
    float som=45;
    int[] records;
    TableRow row;
    records = new int[3];
    for (int i=0; i<voci.length && play==false; i++)voci[i].draw();
    switch(menuState) {
    case 'm'://main
      if (frameCount==startFrame+8) {//Anima i serpenti del menu principale
        startFrame=frameCount;
        fakeSnake1.randAnimation();
        fakeSnake2.randAnimation();
        fakeSnake3.randAnimation();
        fakeSnake4.randAnimation();
        fakeSnake5.randAnimation();
      }
      fakeSnake1.drawSnake();
      fakeSnake2.drawSnake();
      fakeSnake3.drawSnake();
      fakeSnake4.drawSnake();
      fakeSnake5.drawSnake();
      image(logo, xTit, yTit);
      image(music, musX, musY);
      image(nota, musX+18, musY-nota.height);
      if (music==off)image(x, musX+18, musY-nota.height);
      for (int i=0; i<voci.length && play==false; i++)voci[i].draw();
      break;
    case 't'://tutorial
      image(tableRec, xStartField, yStartField-10);
      fill(0);
      text("Tutorial", 30, 50);
      textSize(17);
      text("Una volta selezionato il labirinto e la", 30, 70);
      text("difficoltà desiderata, per iniziare a ", 30, 90);
      text("giocare basterà premere una delle frecce.", 30, 110);
      text("Per muovere il serpente utilizzare le", 30, 130);
      text("frecce, il serpente non può tornare", 30, 150);
      text("indietro su se stesso. Con ogni", 30, 170);
      text("mela mangiata si ottengono 7", 30, 190);
      text(" punti; se si mangiano tre mele", 30, 210);
      text("nell'ordine rosso-celeste-giallo", 30, 230);
      text("si ottengono 100 punti bonus.", 30, 250);
      fill(255);
      textSize(20);
      break;
    case 'r'://record
      image(tableRec, xStartField, yStartField-10);
      fill(0);
      text("Labirinto", 30, 50);
      line(120, 50, 120, yFinishField);
      text("Facile", 140, 50);
      line(195, 50, 195, yFinishField);
      text("Normale", 205, 50);
      line(283, 50, 283, yFinishField);
      text("Difficile", 290, 50);
      textSize(15);
      for (int i=0; i<labirints.length; i++) {//Colonna labirinti
        som+=36;
        //line(20,som-20,xFinishField,som-20);
        text(i+1, 80, som);
        fill(255, 0, 0);
        row = table.getRow(i);
        text(row.getInt("Faci"), 130, som);
        text(row.getInt("Norm"), 205, som);
        text(row.getInt("Dif"), 295, som);
        fill(0);
        line(20, som+13, xFinishField, som+13);
      }
      fill(255);
      textSize(20);
      break;
    case 'l'://labirinto
      labirints[labChoise].drawLabirint();
      fill(0);
      image(tabPoints, 139, 0);
      text("Labirinto " + (labChoise+1), 150, 20);
      fill(255);
      image(leftArrow, posLeftX, posLeftY);
      image(rightArrow, posRightX, posRightY);
      break;
    case 'd'://difficoltà
      fill(0);
      image(tabPoints, 147, 128);
      text("Difficoltà", 160, 150);
      switch(difficult) {
      case 2:
        image(difficile, 138, 185);
        break;
      case 5:
        image(medio, 138, 185);
        break;
      case 8:
        image(facile, 138, 185);
        break;
      }
      image(leftArrow, posLeftX, posLeftY);
      image(rightArrow, posRightX, posRightY);
      fill(255);
      break;
    case 'g'://gioco
      fill(0);
      image(tabPoints, 10, 5, 130, 30);
      text("Punteggio "+points, 20, 25);
      image(tabPoints, 260, 5, 130, 30);
      text("Record  "+table.getInt(labChoise, diffColum), 270, 25);
      fill(255);
      break;
    case 'f'://fine gioco
      image(tabScore, 38, 60);
      fill(0);
      stroke(30);
      text("GAME OVER", 147, 85);
      textSize(18);
      text("Punteggio: "+points, 55, 125);
      //newRecord=true;
      if (newRecord) {
        println("New Record!");
        //image(medal,(width/2-medal.width/2),200);
        //image(rec,(width/2-rec.width/2),225);
      }
      text("Mele mangiate: " +snake.appleEat, 55, 155);
      text("Lunghezza serpente: " + snake.bodyParts, 55, 185);
      textSize(20);
      fill(255);
      break;
    }
  }
  void selectOption(int xClick, int yClick) {
    for (int i=0; i<voci.length; i++) {
      if ( (xClick>=voci[i].xButton && xClick<=voci[i].xButton+voci[i].w_but) && (yClick>=voci[i].yButton && yClick<=voci[i].yButton+voci[i].h_but) && (play==false)) {
        menuState = voci[i].idChoise;
        if (menuState!='g') {//Normal click
          click.play();
          click.rewind();
        } else {
          conferma.play();
          conferma.rewind();
        }
        break;
      }
    }
  }
  void labChoise(int xClick, int yClick) {
    if (menu.menuState=='l') {//scelta labirinto
      if ( (xClick>=posLeftX && xClick<=posLeftX+leftArrow.width) && (yClick>=posLeftY && yClick<=posLeftY+leftArrow.height) ) {//level choose -1.
        click.play();
        click.rewind();
        if (labChoise==0)labChoise = (labirints.length)-1;
        else labChoise = labChoise -1;
      }
      if ( (xClick>=posRightX && xClick<=posRightX+rightArrow.width) && (yClick>=posRightY && yClick<=posRightY+rightArrow.height) ) {//level choose +1.
        click.play();
        click.rewind();
        if (labChoise==((labirints.length)-1))labChoise = 0;
        else labChoise = labChoise + 1;
      }
      //println("labChoise: " + labChoise);
    }
    if (menu.menuState=='d') {//scelta difficoltà
      if ( (xClick>=posLeftX && xClick<=posLeftX+leftArrow.width) && (yClick>=posLeftY && yClick<=posLeftY+leftArrow.height) ) {//difficult +3 (-diff).
        click.play();
        click.rewind();
        if (difficult==8)difficult = 2;
        else difficult = difficult +3;
      }
      if ( (xClick>=posRightX && xClick<=posRightX+rightArrow.width) && (yClick>=posRightY && yClick<=posRightY+rightArrow.height) ) {//difficult -3 (+ diff).
        click.play();
        click.rewind();
        if (difficult==2)difficult = 8;
        else difficult = difficult -3;
      }
      //println("labChoise: " + labChoise);
    }
  }
  void musicOnOff(int xClick, int yClick) {
    if (menu.menuState=='m') {//scelta labirinto
      if ( (xClick>=musX && xClick<=musX+music.width) && (yClick>=musY && yClick<=musY+music.height) ) {//level choose -1.
        if (music==on) {
          music=off;
          menuSong.pause();
        } else {
          music=on;
          menuSong.loop();
        }
      }
    }
  }
}
