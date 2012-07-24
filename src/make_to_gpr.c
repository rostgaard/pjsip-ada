#include <stdlib.h>
#include <stdio.h>
#include <strings.h>

int main (int argc, char* argv[]) {
  int i;
  
  for (i = 1; i < argc; i++) {
    // -D switches
    if(argv[i][0] == '-' && argv[i][1] == 'D') { 
      printf("OK: %s\n",argv[i]);
    }
    // -L switches
    else if(argv[i][0] == '-' && argv[i][1] == 'L') { 
      printf("OK: %s\n",argv[i]);
    }
    // -I switches
    else if(argv[i][0] == '-' && argv[i][1] == 'I') { 
      printf("OK: %s\n",argv[i]);
    }
    // -O switches
    else if(argv[i][0] == '-' && argv[i][1] == 'O') { 
      printf("OK: %s\n",argv[i]);
    }
    // -l switches
    else if(argv[i][0] == '-' && argv[i][1] == 'l') { 
      printf("OK: %s\n",argv[i]);
    }
    else {
      printf("ERROR, Unknown compiler switch %s\n",argv[i]);
      exit(1);
    }
  }
  exit(0);

}
