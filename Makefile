.PHONY: all run run1 run32 run256 run512 run1024

all: iir-inline iir-inline-dyn iir-block iir-block-dyn

run: run1 run32 run256 run512 run1024

run1: all
	./iir-inline 1
	./iir-inline-dyn 1 20
	./iir-block 1
	./iir-block-dyn 1 20

run32: all
	./iir-inline 32
	./iir-inline-dyn 32 20
	./iir-block 32
	./iir-block-dyn 32 20

run256: all
	./iir-inline 256
	./iir-inline-dyn 256 20
	./iir-block 256
	./iir-block-dyn 256 20

run512: all
	./iir-inline 512
	./iir-inline-dyn 512 20
	./iir-block 512
	./iir-block-dyn 512 20

run1024: all
	./iir-inline 1024
	./iir-inline-dyn 1024 20
	./iir-block 1024
	./iir-block-dyn 1024 20

iir-inline: iir_inline.cpp
	g++ -std=c++17 -O3 -W -Wall -o $@ $<

iir-inline-dyn: iir_inline_dyn.cpp
	g++ -std=c++17 -O3 -W -Wall -o $@ $<

iir-block: iir_block.cpp
	g++ -std=c++17 -O3 -W -Wall -o $@ $<

iir-block-dyn: iir_block_dyn.cpp
	g++ -std=c++17 -O3 -W -Wall -o $@ $<
