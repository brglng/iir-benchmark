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

### 1

* CPU: Core i9-13950HX 2.20 GHz
* OS: Ubuntu 24.04 under Windows 10 (WSL2)
* Compiler: GCC 13.2.0
* Number of 2nd order sections: 20

The performance measurement is represented in MCPS (million cycles per second), which means the number of CPU cycles costs per second of input audio data. Smaller is better.

| block\_size              | 1      | 32     | 256    | 512    | 1024   |
| :----------------------- | :----: | :----: | :----: | :----: | :----: |
| iir-sample               | 4.09   | 3.98   | 3.94   | 3.94   | 3.97   |
| iir-sample-var           | 4.12   | 4.10   | 4.07   | 4.14   | 4.02   |
| iir-sample-noinline      | 4.58   | 4.47   | 4.23   | 4.30   | 4.46   |
| iir-sample-var-noinline  | 4.52   | 4.40   | 4.28   | 4.50   | 4.28   |
| iir-block                | 5.46   | 7.46   | 9.56   | 9.63   | 9.69   |
| iir-block-var            | 5.83   | 7.66   | 9.54   | 9.49   | 9.68   |
| iir-sample-virt          |        |        |        |        |        |
| iir-block-virt           |        |        |        |        |        |

### 2
