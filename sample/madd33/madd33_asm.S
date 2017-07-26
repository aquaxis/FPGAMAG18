#define MADD33_OPCODE (0b0001011)
#define REG_A0        (0b01010)

.global madd33

/* z = ( a * m ) + ( b * n ) + ( c * p );の命令 */
madd33: 
      /* データの入力は次のレジスタに入ってくるため、
         レジスタの退避などはありません。
         a0 = a(第1引数)
         a1 = b(第2引数)
         a2 = c(第3引数)
         a3 = d(第4引数)
         a4 = e(第5引数)
         a5 = f(第6引数)
      */
      
      /*
        [ 6: 0] = 0b0001011 : custom-0命令
        [11: 7] = 0b01010   : rd = x10レジスタ
        [31:12] = all zero  : madd33命令では未使用
      */
      .word  MADD33_OPCODE | (REG_A0 << (7))

      /* a0に演算結果が入り、Cソースの関数に戻ります */
      ret
