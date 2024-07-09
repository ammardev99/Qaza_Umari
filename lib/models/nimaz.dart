class Nimaz {
  bool NimazData;
  int Fajar;
  int Zoher;
  int Asr;
  int Maghrib;
  int Isha;
  int Witer;
  Nimaz(
    this.NimazData,
    this.Fajar,
    this.Zoher,
    this.Asr,
    this.Maghrib,
    this.Isha,
    this.Witer,
  );
  void setNimaz(status, int f, int z, int a, int m, int i, int w) {
    NimazData = status;
    Fajar = f;
    Zoher = z;
    Asr = a;
    Maghrib = m;
    Isha = i;
    Witer = w;
  }

  void addPreviousMonth(status, int f, int z, int a, int m, int i, int w) {
    NimazData = status;
    Fajar += f;
    Zoher += z;
    Asr += a;
    Maghrib += m;
    Isha += i;
    Witer += w;
  }

  void printNimazValue() {
    print("\n$NimazData\t$Fajar\t$Zoher\t$Asr\t$Maghrib\t$Isha\t$Witer\t");
  }
}

Nimaz TestMonthlyQazaNimazRecord = Nimaz(true, 0, 0, 0, 0, 0, 0);
Nimaz TestQazaUmariNimazRecord = Nimaz(true, 0, 0, 0, 0, 0, 0);
