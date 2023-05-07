class Labirint
{
  Ostacolo [] ostacoli;

  public Labirint(int nOstacoli) {
    ostacoli = new Ostacolo[nOstacoli];
    for (int i=0; i<ostacoli.length; i++)
      ostacoli[i] = new Ostacolo();
  }
  void drawLabirint() {
    for (int i=0; i<(this.ostacoli).length; i++) {
      fill(this.ostacoli[i].c);
      rect(this.ostacoli[i].posX, this.ostacoli[i].posY, this.ostacoli[i].w, this.ostacoli[i].h);
      fill(snake.standard);
    }
  }
}
