#include	<stdlib.h>
#include	<stdio.h>
#include	<string.h>

#define MAX_WORD 1024

int main(int argc, char *argv[]) {

	FILE	*fpr, *fpw;
	char	buf[256];
	char	file[256];
	int	i;
	int	c;
	int	pc;
	int	unit;
	int size;

	if ( argc == 1 ) {
		fprintf( stderr, "usage: %s [-2|-4] <filename>\n", argv[0] );
		exit(-1);
	}

	if ( !strcmp( argv[1] , "-4" ) ) {
		unit = 4;
		strcpy( file, argv[ 2 ] );
	} else if ( !strcmp( argv[1] , "-2" ) ) {
		unit = 2;
		strcpy( file, argv[ 2 ] );
	} else {
		unit = 1;
		strcpy( file, argv[ 1 ] );
	}

	sprintf(buf, "%s.bin", file );
	fpr = fopen(buf, "r" );
  fseek(fpr, 0L, SEEK_END);
  size = ftell(fpr);
  fseek(fpr, 0L, SEEK_SET);

	size = size / unit;

	sprintf(buf, "%s.mif", file );
	fpw = fopen(buf, "w" );

	fprintf( fpw, "DEPTH = %d;\n", size); 
//	fprintf( fpw, "DEPTH = %d;\n", MAX_WORD); 
	fprintf( fpw, "WIDTH = %d;\n", 8 * unit);
	fprintf( fpw, "ADDRESS_RADIX = HEX;\n");
	fprintf( fpw, "DATA_RADIX = HEX;\n");
	fprintf( fpw, "CONTENT\n");
	fprintf( fpw, "BEGIN\n");

	pc = 0;
	while ( pc < size ) {
		fprintf( fpw, "%04x : ", pc );
		fread(&c, unit, 1, fpr);
		switch(unit){
			case 1:		fprintf(fpw, "%02x;\n", c); break;
			case 2:		fprintf(fpw, "%04x;\n", c); break;
			case 4:		fprintf(fpw, "%08x;\n", c); break;
		}
		++pc;
	}
/*
	while ( pc < MAX_WORD ){
		fprintf( fpw, "%04x : 00000000;\n", pc );
		++pc;
	}
*/
	fprintf(fpw, "END;\n");
	fclose( fpr );
	fclose( fpw );
}
