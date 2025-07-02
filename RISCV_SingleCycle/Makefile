# Makefile inteligente para compilacao e simulacao com suporte a memoria separada

# Comando 'make' : para simular e gerar log de simulação do vvp em "simulação.txt"
# Comando 'make .data' : para observar ser compilador reservou dados para o .hex e quais são
# Comando 'make wave' : para abrir gtkwave com layout já pronto
# Comando 'make rtl' : para gerar imagem png a partir do rtl em svg gerado por yosys+netlistsvg
# Se der "Nada a ser feito para "all", fazer "make .PHONY" ou "make clean"

# Ferramentas
GCC=riscv32-unknown-elf-gcc
OBJDUMP=riscv32-unknown-elf-objdump
OBJCOPY=riscv32-unknown-elf-objcopy
XXD=xxd
IVERILOG=iverilog
VVP=vvp
GTKWAVE=gtkwave
YOSYS=yosys
NETSVG=netlistsvg
INK=inkscape

# Arquivos de entrada
LINKER=linker.ld
CRT=crt0.s
SRC=vetor.c
BASE=$(basename $(SRC))
ELF=$(BASE).elf
ASM=$(BASE).asm
INSTR_BIN=$(BASE)_instr.bin
DATA1_BIN=$(BASE)_data1.bin
DATA2_BIN=$(BASE)_data2.bin
DATA_BIN=$(BASE)_data.bin
INSTR_HEX=$(BASE)_instr.hex
DATA_HEX=$(BASE)_data.hex

# Arquivos Verilog
VFILES=tb_RISCV_TOP.v RISCV_TOP.v
SIM=sim.out
SIMLOG=simulacao.txt

# Arquivos GTKWAVE
WAVE=waveform.vcd
LAYOUT=waveform_layout.gtkw

# Arquivos RTL
JSON=.json
SVG=RISCV_TOP.svg
PNG=RISCV_TOP.png

# Regra principal
all: $(ASM) $(INSTR_HEX) maybe_data_hex $(SIMLOG)

# Compila o ELF
$(ELF): $(LINKER) $(CRT) $(SRC)
	$(GCC) -nostdlib -ffreestanding -O0 -T $(LINKER) $(CRT) $(SRC) -o $(ELF)

# Dump do assembly
$(ASM): $(ELF)
	$(OBJDUMP) -d $(ELF) > $(ASM)

# Gera instrucoes bin/hex
$(INSTR_BIN): $(ELF)
	$(OBJCOPY) -O binary --only-section=.text $(ELF) $(INSTR_BIN)

$(INSTR_HEX): $(INSTR_BIN)
	$(XXD) -p -c 4 $(INSTR_BIN) | awk '{print substr($$0,7,2) substr($$0,5,2) substr($$0,3,2) substr($$0,1,2)}' > $(INSTR_HEX)

# Gera dados bin/hex se houver .data ou .rodata
maybe_data_hex: $(ELF)
	@if $(OBJDUMP) -h $(ELF) | grep -qE '\.data|\.rodata'; then \
		echo "[INFO] Gerando .data/.rodata para $(DATA_HEX)"; \
		$(OBJCOPY) -O binary --only-section=.data $(ELF) $(DATA1_BIN) || true; \
		$(OBJCOPY) -O binary --only-section=.rodata $(ELF) $(DATA2_BIN) || true; \
		cat $(DATA2_BIN) $(DATA1_BIN) > $(DATA_BIN); \
		$(XXD) -p -c 4 $(DATA_BIN) | awk '{print substr($$0,7,2) substr($$0,5,2) substr($$0,3,2) substr($$0,1,2)}' > $(DATA_HEX); \
	else \
		echo "[INFO] Nenhuma secao .data/.rodata encontrada. Pulando geracao de dados."; \
		touch $(DATA_HEX); \
	fi

# Compila Verilog
$(SIM): $(VFILES)
	$(IVERILOG) -o $(SIM) $(VFILES)

# Executa simulacao
$(SIMLOG): $(SIM) $(INSTR_HEX) $(DATA_HEX)
	$(VVP) $(SIM) > $(SIMLOG)

# Gera GTKWAVE
wave:
	$(GTKWAVE) $(WAVE) $(LAYOUT) >/dev/null 2>&1 < /dev/null &

# Gera RTL
rtl: $(PNG) 

# Gera JSON
$(JSON): $(VFILES)
	$(YOSYS) -p "prep -top RISCV_TOP; write_json $(JSON)" $(VFILES)

# Gera SVG
$(SVG): $(JSON)
	$(NETSVG) $(JSON) -o $(SVG)

# Transforma em PNG com fundo branco
$(PNG): $(SVG)
	$(INK) $(SVG) --export-type=png --export-background=white
	eog $(PNG) >/dev/null 2>&1 < /dev/null &
# Limpeza
clean:
	rm -f $(ELF) $(ASM) $(INSTR_BIN) $(INSTR_HEX) \
		$(DATA1_BIN) $(DATA2_BIN) $(DATA_BIN) $(DATA_HEX) \
		$(SIM) $(SIMLOG) $(WAVE) $(JSON) $(SVG) $(PNG)

.PHONY: all clean maybe_data_hex
