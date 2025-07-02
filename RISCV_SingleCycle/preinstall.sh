#!/bin/bash

riscv32_cmd=riscv32-unknown-elf-gcc
icarus_cmd=/usr/local/bin/iverilog
gtkwave_cmd=/usr/bin/gtkwave
yosys_cmd=/usr/bin/yosys
netlist_cmd=/usr/local/bin/netlistsvg
inkscape_cmd=/usr/bin/inkscape

echo "Checando se possui o compilador riscv."

if [[ -f "$HOME/riscv32/bin/$riscv32_cmd" || -f "/usr/bin/riscv32/bin/$riscv32_cmd" ]];
then
	echo "Compilador riscv32 instalado."
else
	echo "Precisa instalar compilador riscv-toolchain."
fi

echo "Checando se possui Icarus e GTKwave."

if [[ -f $icarus_cmd ]];
then
        echo "Icarus instalado."
else
        echo "Precisa instalar Icarus."
	sudo apt update && sudo apt install iverilog

        if [ $? -eq 0 ];
        then
                echo "Instalação do Icarus com sucesso."
        else
                echo "Instalação do Icarus falhou."
        fi 

fi

if [[ -f $gtkwave_cmd ]];
then
        echo "GTKWave instalado."
else
        echo "Precisa instalar GTKWave."
        sudo apt update && sudo apt install gtkwave 


        if [ $? -eq 0 ];
        then
                echo "Instalação do GTKWave com sucesso."
        else
                echo "Instalação do GTKWave falhou."
        fi 
fi

echo "Checando se possui Yosys e Netlistsvg."

if [[ -f $yosys_cmd ]];
then
        echo "Yosys instalado."
else
        echo "Precisa instalar Yosys."
        sudo apt update && sudo apt install yosys 


        if [ $? -eq 0 ];
        then
                echo "Instalação do Yosys com sucesso."
        else
                echo "Instalação do Yosys falhou."
        fi 
fi

if [[ -f $netlist_cmd ]];
then
        echo "Netlistsvg instalado."
else
        echo "Precisa instalar Netlistsvg."
        sudo apt update && sudo apt install nodejs npm
	sudo apt install -g netlistsvg 


        if [ $? -eq 0 ];
        then
                echo "Instalação do Netlistsvg com sucesso."
        else
                echo "Instalação do Netlistsvg falhou."
        fi 
fi

if [[ -f $inkscape_cmd ]];
then
        echo "Inkscape instalado."
else
        echo "Precisa instalar Inkscape."
        sudo apt update && sudo apt install inkscape


        if [ $? -eq 0 ];
        then
                echo "Instalação do Inkscape com sucesso."
        else
                echo "Instalação do Inkscape falhou."
        fi 
fi

echo "---- Icarus Verilog ----"
iverilog -V
echo "---- GTKWave ----"
gtkwave --version
echo "---- Yosys ----"
yosys -V
echo "---- Netlistsvg ----"
netlistsvg --version
echo "---- Inkscape ----"
inkscape --version







