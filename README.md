# iir-benchmark

Benchmark for different approaches of implementing cascaded 2nd order IIR filters in C++.

|                | processing   | section's process function is inlined?  | number of sections is compile-time? | dynamic dispatch? |
| :------------- | :----------: | :-------------------------------------: | :---------------------------------: | :---------------: |
| iir-inline     | sample-based | yes                                     | yes                                 | no                |
| iir-inline-dyn | sample-based | yes                                     | no                                  | no                |
| iir-block      | frame-based  | no                                      | yes                                 | no                |
| iir-block-dyn  | frame-based  | no                                      | yes                                 | no                |

* sample-based: The section's `process` function processes only 1 sample. The caller's loop processes sample-by-sample, and calls each sction's `process` function in the loop body.
* frame-based: The sections's `process` function processes a frame (block). The caller's loop just calls each section's `process` function.
* dynamic dispatch: The section's `process` function is a virtual function and is not inlined/optimized by the compiler.

## Compile

```sh
make
```

## Run

```sh
make run
```

## Result

CPU: 
OS:

The performance measurement is represented in MCPS (million cycles per second), which means the number of CPU cycles costs per second of input audio data. Lower is better.

| block\_size    | 1      | 32     | 256    | 512    | 1024   |
| :------------- | :----: | :----: | :----: | :----: | :----: |
| iir-inline     |        |        |        |        |        |
| iir-inline-dyn |        |        |        |        |        |
| iir-block      |        |        |        |        |        |
| iir-block-dyn  |        |        |        |        |        |
