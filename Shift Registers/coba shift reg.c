#include <stdio.h>

void out(unsigned char data)
{
  unsigned char final, temp, n = 7, m;
  for (m = 0; m < 8; m++)
  {
    temp = data;
    temp = temp << n;
    final = temp >> (n + m);
    printf("Output ke-%d = %d\n",(m+1),final);
    n--;
  }
}

main()
{
  out(1);
  return 0;
}
