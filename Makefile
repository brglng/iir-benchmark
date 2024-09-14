.PHONY: all all-tests run run1 run32 run256 run512 run1024

all: chirp all-tests

all-tests: iir-sample iir-sample-var iir-sample-noinline iir-sample-var-noinline iir-block iir-block-var

run: run1 run32 run256 run512 run1024

SECTIONS ?= 20
DURATION ?= 600

run1: chirp all-tests
	@./chirp $(DURATION)
	@./iir-sample 1
	@./iir-sample-var 1 $(SECTIONS)
	@./iir-sample-noinline 1
	@./iir-sample-var-noinline 1 $(SECTIONS)
	@./iir-block 1
	@./iir-block-var 1 $(SECTIONS)

run32: chirp all-tests
	@./chirp $(DURATION)
	@./iir-sample 32
	@./iir-sample-var 32 $(SECTIONS)
	@./iir-sample-noinline 32
	@./iir-sample-var-noinline 32 $(SECTIONS)
	@./iir-block 32
	@./iir-block-var 32 $(SECTIONS)

run256: chirp all-tests
	@./chirp $(DURATION)
	@./iir-sample 256
	@./iir-sample-var 256 $(SECTIONS)
	@./iir-sample-noinline 256
	@./iir-sample-var-noinline 256 $(SECTIONS)
	@./iir-block 256
	@./iir-block-var 256 $(SECTIONS)

run512: chirp all-tests
	@./chirp $(DURATION)
	@./iir-sample 512
	@./iir-sample-var 512 $(SECTIONS)
	@./iir-sample-noinline 512
	@./iir-sample-var-noinline 512 $(SECTIONS)
	@./iir-block 512
	@./iir-block-var 512 $(SECTIONS)

run1024: chirp all-tests
	@./chirp $(DURATION)
	@./iir-sample 1024
	@./iir-sample-var 1024 $(SECTIONS)
	@./iir-sample-noinline 1024
	@./iir-sample-var-noinline 1024 $(SECTIONS)
	@./iir-block 1024
	@./iir-block-var 1024 $(SECTIONS)

chirp: chirp.cpp
	g++ -std=c++17 -O3 -W -Wall -o $@ $<

iir-sample: iir_sample.cpp
	g++ -std=c++17 -O3 -W -Wall -o $@ $< -DSECTIONS=$(SECTIONS)

iir-sample-var: iir_sample_var.cpp
	g++ -std=c++17 -O3 -W -Wall -o $@ $<

iir-sample-noinline: iir_sample_noinline.cpp
	g++ -std=c++17 -O3 -W -Wall -o $@ $< -DSECTIONS=$(SECTIONS)

iir-sample-var-noinline: iir_sample_var_noinline.cpp
	g++ -std=c++17 -O3 -W -Wall -o $@ $<

iir-block: iir_block.cpp
	g++ -std=c++17 -O3 -W -Wall -o $@ $< -DSECTIONS=$(SECTIONS)

iir-block-var: iir_block_var.cpp
	g++ -std=c++17 -O3 -W -Wall -o $@ $<
