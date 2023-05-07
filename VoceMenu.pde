class VoceMenu {
  int xButton, yButton;
  int w_but, h_but;
  String description;
  char idChoise;
  PImage button;

  public VoceMenu(int x, int y, int w, int h, String str, char id) {//Senza immagine
    idChoise = id;
    xButton = x;
    yButton = y;
    w_but = w;
    h_but = h;
    description = new String(str);
  }
  public VoceMenu(int x, int y, PImage img, String str, char id) {//Con immagine
    button = img;
    idChoise = id;
    xButton = x;
    yButton = y;
    w_but = button.width;
    h_but = button.height;
    description = new String(str);
  }
  void draw() {
    if (button!=null) {//Button con immagine
      image(button, xButton, yButton);
      fill(0);
      text(description, xButton+5, yButton+5);
      fill(255);
    } else {//Button con rettangolo
      fill(255);
      rect(xButton, yButton, w_but, h_but);
    }
    fill(0);
    text(description, xButton+5, yButton+20);
    fill(255);
  }
}
