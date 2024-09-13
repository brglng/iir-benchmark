# iir-benchmark

Benchmark for different approaches of implementing cascaded 2nd order IIR filters in C++.

|                         | processing   | sections' `process` functions are inlined? | number of sections is a compile-time constant? | dynamic dispatch? |
| :---------------------- | :----------: | :----------------------------------------: | :--------------------------------------------: | :---------------: |
| iir-sample              | sample-based | yes                                        | yes                                            | no                |
| iir-sample-var          | sample-based | yes                                        | no                                             | no                |
| iir-sample-noinline     | sample-based | no                                         | yes                                            | no                |
| iir-sample-var-noinline | sample-based | no                                         | no                                             | no                |
| iir-block               | frame-based  | no                                         | yes                                            | no                |
| iir-block-var           | frame-based  | no                                         | no                                             | no                |
| iir-sample-virt         | sample-based | no                                         | no                                             | yes               |
| iir-block-virt          | frame-based  | no                                         | no                                             | yes               |

* sample-based: Each section's `process` function processes only 1 sample. The caller's loop processes sample-by-sample, and calls each section's `process` function in the loop body.
* frame-based: Each section's `process` function processes a frame (block). The caller just calls each section's `process` function.
* dynamic dispatch: Each section's `process` function is a virtual function and is made not to be inlined/optimized by the compiler.

## Compile

```sh
make
```

## Run

```sh
make run
```

## Result

CPU: Core i9-13950HX 2.20 GHz

OS: Ubuntu 24.04 under Windows 10 (WSL2)

The performance measurement is represented in MCPS (million cycles per second), which means the number of CPU cycles costs per second of input audio data. Smaller is better.

| block\_size              | 1      | 32     | 256    | 512    | 1024   |
| :----------------------- | :----: | :----: | :----: | :----: | :----: |
| iir-sample               | 4.13   | 3.95   | 3.95   | 4.02   | 4.03   |
| iir-sample-var           | 4.20   | 4.19   | 4.10   | 4.15   | 4.15   |
| iir-sample-noinline      |        |        |        |        |        |
| iir-sample-var-noinline  |        |        |        |        |        |
| iir-block                | 5.79   | 7.65   | 9.56   | 9.82   | 10.85  |
| iir-block-var            | 5.85   | 7.70   | 9.68   | 9.90   | 10.02  |
| iir-sample-virt          |        |        |        |        |        |
| iir-block-virt           |        |        |        |        |        |
