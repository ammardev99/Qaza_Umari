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
  void setNimaz(d, int f, int z, int a, int m, int i, int w) {
    NimazData = d;
    Fajar = f;
    Zoher = z;
    Asr = a;
    Maghrib = m;
    Isha = i;
    Witer = w;
  }

  void printNimazValue() {
    print("\n$Fajar\t$Zoher\t$Asr\t$Maghrib\t$Isha\t$Witer\t");
  }
}

Nimaz MonthlyQazaNimazRecord = Nimaz(true, 0, 0, 0, 0, 0, 0);
