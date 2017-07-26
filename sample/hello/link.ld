SECTIONS
{
  . = 0x00000000;
  .text.init : { *(.text.init) }
  .text ALIGN(0x100) : { *(.text) }
  .data ALIGN(0x400) : { *(.data) }
  .bss ALIGN(0x400)  : { *(.bss) }
  _bss_end = .;
  end = .;
  _end = .;
}
