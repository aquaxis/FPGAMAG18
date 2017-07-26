#include <stdio.h>

#define UART_STATUS (0x80000000+0x00)
#define UART_INTEN  (0x80000000+0x04)
#define UART_TXBUF  (0x80000000+0x08)
#define UART_RXBUF  (0x80000000+0x0C)

#define UART_TXFULL_MASK  (0x0300)
#define UART_RXEMPTY_MASK (0x0001)

const char *buf = "Hello World !\r\n";

int main()
{
  int i = 0;

  while(1){
    // UARTのTxバッファがFullになっていなければHello WWorldを出力する
    while(((*(volatile int *)(UART_STATUS)) & UART_TXFULL_MASK) > 0);
    // Txバッファへの書込
    *(volatile int *)(UART_TXBUF) = buf[i];
    i++;
    // 文字列を最後まで出力したらwhile(1)を抜け出す
    if(buf[i] == 0x0) break;
  }


  // エコーバック
  int rxdata;
  while(1){
    // RXバッファのEMPTYを監視
    while(((*(volatile int *)(UART_STATUS)) & UART_RXEMPTY_MASK) > 0);
    // RXバッファから読み出し
    rxdata = *(volatile int *)(UART_RXBUF);

    // UARTのTxバッファがFullになっていなければHello WWorldを出力する
    while(((*(volatile int *)(UART_STATUS)) & UART_TXFULL_MASK) > 0);
    // Txバッファへの書込
    *(volatile int *)(UART_TXBUF) = rxdata;
  }; // 永久ループ

  return 0;
}
