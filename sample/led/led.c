#define GPIO_OUT (0x80000000+0x0100)
#define GPIO_IN  (0x80000000+0x0104)
#define GPIO_DIR (0x80000000+0x0108)

int main()
{
  int i;
  int led = 0;

  // GPIOの出力設定
  *(volatile int *)(GPIO_DIR) = 0x00000000F;

  while(1){
    *(volatile int *)(GPIO_OUT) = led; // GPIO(LED)へ出力
    for(i=0;i<2500000;i++); // 約1秒周期で点滅するように調整
    led = ~led;
  }

  return 0;
}
