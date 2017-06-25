#include <stdio.h>
#include "lfsr.h"

int main()
{
    const unsigned int init = 1;
    unsigned int v = init;
    unsigned int random_bits;
    /*do {
      v = shift_lfsr(v);
      random_bits = (v & 0xffff);
      printf("%d\n", random_bits);
      //putchar(((v & 1) == 0) ? '0' : '1');
    } while (v != init);*/

    int i;
    for (i = 0; i < 20; ++i)
    {
    	v = shift_lfsr(v);
      	random_bits = (v & 0xffff);
      	printf("%04x\n", random_bits);
    }
}
