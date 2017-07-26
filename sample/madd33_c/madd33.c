#include <stdio.h>

#define UART_STATUS (0x80000000+0x00)
#define UART_INTEN  (0x80000000+0x04)
#define UART_TXBUF  (0x80000000+0x08)
#define UART_RXBUF  (0x80000000+0x0C)

#define UART_TXFULL_MASK  (0x0300)
#define UART_RXEMPTY_MASK (0x0003)

//extern int madd33(int, int, int, int, int, int);

int madd33(
  int a, int m,
  int b, int n,
  int c, int p
  )
{
  int z;
  z = ( a * m ) + ( b * n ) + ( c * p );
  return z;
}

void out_hex(char a)
{
    // UARTのTxバッファがFullになっていなければHello WWorldを出力する
    while(((*(volatile int *)(UART_STATUS)) & UART_TXFULL_MASK) > 0);

    a &= 0x0F; /* 念の為に下位4ビットにマスク */

    if( a >= 10 ){
      /* ASCIIコードのa〜f */
      a += 0x61;
    }else{
      /* ASCIIコードの0〜9 */
      a += 0x30;
    }

    // Txバッファへの書込
    *(volatile int *)(UART_TXBUF) = a;
}

int main()
{
  int i = 0;

  int a = 10;
  int b = 15;
  int c = 20;
  int m = 1;
  int n = 2;
  int p = 3;

  int rslt = 0;

  /*
    madd33は次の演算結果を返す
    z = ( a * m ) + ( b * n ) + ( c * p );
  */
  rslt = madd33( a, m, b, n, c, p );

  /* Hexを1文字ずつ出力する */
  for( i = 0; i < 8; i++ ){
    out_hex( (rslt >> ( 28 - ( 4 * i ))) & 0x0F );
  }

  while(1); // 永久ループ

  return 0;
}
