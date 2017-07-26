 #define STACK_TOP (_end + 1024)

    .section .text.init
    .align 6
    .globl _start
    .globl _bss_end
_start:
    j reset_vector
    .align 2
trap_vector:
#    <<<トラップの内容>>>
handle_exception:
#    <<<割込みハンドラの内容>>>
other_exception:
#    <<<他のハンドラの内容>>>
reset_vector:
#    <<<初期化内容>>>
#    li sp, 4096     # スタックポインタのアドレス
    la sp, STACK_TOP # スタックポインタのアドレス

    auipc t0,0x0    # PCをレジスタに退避
    addi  t0,t0,16  # mretのアドレス
    csrw  mepc,t0   # MEPCにアドレスをセット
    call  main      # mainへジャンプ
    mret            # MEPCへ飛んでいく
