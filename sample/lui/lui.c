#define N 3

int main()
{
  int w;
  int i,j,k;

  int a[N][N];

  a[0][0] = 64044;
  a[0][1] = 74992;
  a[0][2] = 91875;
  a[1][0] = 51040;
  a[1][1] = 60223;
  a[1][2] = 74725;
  a[2][0] = 92157;
  a[2][1] = 52271;
  a[2][2] = 94080;

  for(k=0;k<N;k++){
    w = 1/a[k][k];
    for(i=0;i<N;i++){
      a[i][k] = w*a[i][k];
      for(j=0;j<N;j++){
        a[i][j] = a[i][j] - a[i][k] * a[k][j];
      }
    }
  }

  *(volatile int *)0x00000800 = 0x00000001;

  return 0;
}
