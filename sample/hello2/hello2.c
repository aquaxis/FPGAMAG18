#include <stdio.h>

const char *buf = "Hello World !\n";

int main()
{
  //puts("Hello World !\n");
  int i = 0;

  while(1){
    for(i=0;i<25000000;i++); // 1sec
    puts("Hello World !\n");
  }
  
  return 0;
}

int __errno()
{
  return 0;
}
