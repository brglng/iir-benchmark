.PHONY: all run run1 run32 run256 run512 run1024

all: iir-inline iir-inline-var iir-block iir-block-var

run: run1 run32 run256 run512 run1024

run1: all
	./iir-inline 1
	./iir-inline-var 1 20
	./iir-block 1
	./iir-block-var 1 20

run32: all
	./iir-inline 32
	./iir-inline-var 32 20
	./iir-block 32
	./iir-block-var 32 20

run256: all
	./iir-inline 256
	./iir-inline-var 256 20
	./iir-block 256
	./iir-block-var 256 20

run512: all
	./iir-inline 512
	./iir-inline-var 512 20
	./iir-block 512
	./iir-block-var 512 20

run1024: all
	./iir-inline 1024
	./iir-inline-var 1024 20
	./iir-block 1024
	./iir-block-var 1024 20

iir-inline: iir_inline.cpp
	g++ -std=c++17 -O3 -W -Wall -o $@ $<

iir-inline-var: iir_inline_var.cpp
	g++ -std=c++17 -O3 -W -Wall -o $@ $<

iir-block: iir_block.cpp
	g++ -std=c++17 -O3 -W -Wall -o $@ $<

iir-block-var: iir_block_var.cpp
	g++ -std=c++17 -O3 -W -Wall -o $@ $<
