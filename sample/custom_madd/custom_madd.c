int up_custom_madd(int, int, int, int, int, int);

int main()
{
#if 0
    unsigned int x = 123, y = 456, z = 0;
  // load x into accumulator 2 (funct=0)
  asm volatile ("custom0 x0, %0, 2, 0" : : "r"(x));
  // read it back into z (funct=1) to verify it
  asm volatile ("custom0 %0, x0, 2, 1" : "=r"(z));
//  assert(z == x);
  // accumulate 456 into it (funct=3)
  asm volatile ("custom0 x0, %0, 2, 3" : : "r"(y));
  // verify it
  asm volatile ("custom0 %0, x0, 2, 1" : "=r"(z));
//  assert(z == x+y);
  // do it all again, but initialize acc2 via memory this time (funct=2)
  asm volatile ("custom0 x0, %0, 2, 2" : : "r"(&x));
  asm volatile ("custom0 x0, %0, 2, 3" : : "r"(y));
  asm volatile ("custom0 %0, x0, 2, 1" : "=r"(z));
//  assert(z == x+y);
#endif
  int a, b, c, d, e, f, z;

  a = 10;
  b = 11;
  c = 12;
  d = 13;
  e = 14;
  f = 15;

//asm volatile ("custom0 %0, %1, %2, 0" : "=r"(z) : "r"(a), "r"(b));
//asm volatile ("custom0");
  z = up_custom_madd(a, b, c, d, e, f);
#if 0
  __asm__("custom0 %0;" /* 出力オペランド(y)をt0に代入する */
            :"=r"(z)          /* 変数yを出力オペランドとする */
            :           /* 入力オペランドはなし */
    );
#endif
  *(volatile int *)0x80000000 = z;

  return 0;
}
