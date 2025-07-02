------------------------------------------------------------------------------------------------------
/// Sobre a implementação
- Implementação didática de core rv32i single cycle com datapath semelhante ao de livro didático (Arquitetura.png)
- Com algumas adições como (Arquitetura_com_adicoes.png):
    - sinal 'jump' para instruções que precisam pular imediatamente para o 
      PC+Immediato (não depende de branch + sinal zero da ALU)
    - Sinal 'jarl' para pular o PC para o resultado da ALU que é rs1 + Imme que vem da instrução JALR
    - Um segundo Mux na entrada da ALU além do (reg2 | Immediato) para AUIPC 
      que precisa somar o imediato com o PC
    - Mux que decide entre ALU e Mem de Dados foi substituído por um que decide ente PC4, Mem Dados e ALU
      isso para as instruções JAL e JALR
    - Mux do PC foi modificado para decidir entre Adder, PC4 e ALU( jalr: rs1 + imme), com sel 
      que decide ente sinais de Branch+Zero, Jump e Jalr em trecho de código combinacional no 'RISCV_TOP.v'
- O testbench precisa que se coloque um "ecall" antes da função main() retornar 0 (terminar)
  pois a simulação termina quando encontrar "ecall".
- Possui memória de dados (RAM) separada da memória de instrução (ROM). A RAM acessada pela ALU (informando
  endereços calculados no assembly) e a ROM acessada somente PC.
  - A memória de instruções só serve para instruções e precisa carregar o .hex somente com a instruções
    do programa em 'Instruction_Memory.v' "$readmemh("app_instr.hex", mem);"
  - A memória de dados precisa receber o .hex com os dados de variáveis inicializadas em
    'Data_Memory.v' "$readmemh("app_data.hex", mem);"
  - Esses .hex são gerados no make file.

//// Sobre programas que precisam estar instalados
- riscv gcc toolchain (compilador riscv)
- Icarus verilog + GTKWave  
- yosys
- Netlistsvg
- inkscape

------------------------------------------------------------------------------------------------------

Para simulação no Quartus:
  - Comentar os "include" no toplevel 'RISCV_TOP.v'
  - O Waveform é para quando a 'Instruction_Memory.v' for toplevel
  - O Waveform4 é para 'Data_Memory.v' como toplevel
  - O Waveform2 é para o 'Register_File.v' como toplevel
  - O Waveform3 é para o toplevel principal 'RISCV_TOP.v'

------------------------------------------------------------------------------------------------------

//// Sobre Makefile
- Há um Makefile com os principais comandos de geração de elf, bin, hex, assembly, e 
  simulação no icarus verilog.
- Gera .hex de instruções com a sessão .text do linker e .hex de dados das sessões .data, rodata, sdata.
- Verifica se o .elf compilado possui sessões de dados inicializados (.data, .rodata, .sdata), e se tiver
  gera o .hex com esses dados, se não, gera .hex vazio.
- Modificar o Makefile de acordo com seu código em C e com seus arquivos .v (testbench e demais)
- Makefile para compilação e simulação no icarus verilog vvp
- Se der "Nada a ser feito para "all", fazer "make .PHONY" ou "make clean"
- Lembrar que esses arquivos precisam estar na mesma pasta onde o make é executado
- Mudar "Arquivos de Entrada": 
  - o nome do .c da aplicação para gerar seu .hex que vai ser usado no memory.v
    em SRC=aplicação.c
- Lembrar de modificar em 'Instruction_Memory.v' "$readmemh("media_instr.hex", mem);" com o aplicação_instr.hex
- Lembrar de modificar em 'Data_Memory.v' "$readmemh("media_data.hex", mem);" com o aplicação_data.hex

//// Sobre Comandos do Makefile
# Comando 'make' : para simular e gerar log de simulação do vvp em "simulação.txt"
# Comando 'make .data' : para observar ser compilador reservou dados para o .hex e quais são
# Comando 'make wave' : para abrir gtkwave com layout já pronto
# Comando 'make rtl' : para gerar imagem png a partir do rtl em svg gerado por yosys+netlistsvg
# Se der "Nada a ser feito para "all", fazer "make .PHONY" ou "make clean"

------------------------------------------------------------------------------------------------------

//// Sobre exemplos de códigos em C presentes na pasta
- Tem media.c com cálculos como soma, e divisão
- Tem for.c com loop para testar instruções de branch e jump
- Tem switch.c para testar também esse tipo de instrução
- Tem vetor.c com vetor inicializado (testar compilação de códigos mais complexos que tem variáveis inicializadas
  e loops)
- Tem fft.c que possui vetores inicializados e 3 "for" um dentro do outro

//// Para saber os valores de códigos, rodar uma versão com printf com qemu-riscv32
Ex.:
riscv32-unknown-elf-gcc fft.c
qemu-riscv32 ./a.out
      X[0] = 0 + 0i
      X[1] = 0 + 0i
      X[2] = 4000 + 0i
      X[3] = 4000 + 0i
      X[4] = 0 + 0i
      X[5] = 0 + 0i
      X[6] = 0 + 0i
      X[7] = 0 + 0i

------------------------------------------------------------------------------------------------------

//// Se quiser fazer todos os passos manualmente sem ser pelo "make":

------------------------------------------------------------------------------------------------------
Gera o .hex do código em C  // Para se for usar somente memória de instruções inicializada
------------------------------------------------------------------------------------------------------

riscv32-unknown-elf-gcc -march=rv32i -mabi=ilp32 -nostartfiles -Wl,--no-relax -o media.elf media.c

riscv32-unknown-elf-objcopy -O binary media.elf media.bin

---Gera .hex que coloca no arquivo 'Instruction_Memory.v' em "$readmemh("media.hex",memory);"

xxd -p -c 4 media.bin | awk '{print substr($0,7,2) substr($0,5,2) substr($0,3,2) substr($0,1,2)}' > media.hex

---Gerar Assembly

riscv32-unknown-elf-objdump -d media.elf > media.asm

------------------------------------------------------------------------------------------------------
Gera os .hex separados do código em C 
------------------------------------------------------------------------------------------------------

---Compila gerando .elf
riscv32-unknown-elf-gcc -nostdlib -ffreestanding -O0 -T linker.ld crt0.s fft2.c -o fft2.elf

---Verifica se tem dados inicializados (.data, .rodata, .sdata)
riscv32-unknown-elf-objdump -s -j .data -j .rodata fft2.elf

---Gera arquivo com assembly
riscv32-unknown-elf-objdump -d fft2.elf > fft2.asm

---Gera .bin de instruções 
riscv32-unknown-elf-objcopy -O binary --only-section=.text fft2.elf fft2_instr.bin

---Gera .bin de dados (um de .data outro de .rodata)
riscv32-unknown-elf-objcopy -O binary --only-section=.data fft2.elf fft2_data1.bin

riscv32-unknown-elf-objcopy -O binary --only-section=.rodata fft2.elf fft2_data2.bin
----Concatena na ordem que está no linker.ld
cat fft2_data2.bin fft2_data1.bin > fft2_data.bin

----Gera .hex de instruções para ser alimentado em 'Instruction_Memory.v'
xxd -p -c 4 fft2_instr.bin | awk '{print substr($0,7,2) substr($0,5,2) substr($0,3,2) substr($0,1,2)}' > fft2_instr.hex

---Gera .bin de dados (um de .data outro de .rodata) para ser alimentado em 'Data_Memory.v'
xxd -p -c 4 fft2_data.bin | awk '{print substr($0,7,2) substr($0,5,2) substr($0,3,2) substr($0,1,2)}' > fft2_data.hex

------------------------------------------------------------------------------------------------------
Comandos para o Icarus
------------------------------------------------------------------------------------------------------

--- Gera arquivo de simulação para depois ser mostrado no "vvp" (tem que ter testbench e toplevel -com include dos modulos)
iverilog -o sim.out tb_RISCV_TOP.v RISCV_TOP.v

--- Gera saída da simulação em um arquivo txt. Pode ser vendo no terminal (sem "> simulação.txt")
vvp sim.out > simulacao.txt

------------------------------------------------------------------------------------------------------
Comandos para o GTKWave
------------------------------------------------------------------------------------------------------

--- Abrindo Waveform.vcd para editar e organizar os sinais como quer
gtkwave waveform.vcd

--- Abrinfo o Waveform.vcd em um layout já pre-organizado e com formatos de visualização (binario, decimal, etc) pre-atribuitos
gtkwave waveform.vcd waveform_layout.gtkw

------------------------------------------------------------------------------------------------------
Comandos para o YOSYS
------------------------------------------------------------------------------------------------------

--- Gerando um arquivo com número de células (entidades lógicas básicas)
yosys -p "read_verilog RISCV_TOP.v; synth -top RISCV_TOP; stat" > yosys_area.txt


--- YOSYS + Netlistsvg para gerar RTL
yosys -p "prep -top RISCV_TOP; write_json RISCV_TOP.json" RISCV_TOP.v
netlistsvg RISCV_TOP.json -o RISCV_TOP.svg
inkscape RISCV_TOP.svg --export-type=png --export-background=white
eog RISCV_TOP.pngriscv32
